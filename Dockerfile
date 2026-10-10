FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
# RUN npm run build
# Astro 5 内容层在 Docker 冷缓存首次构建时存在竞态，会静默丢失部分文章
# 构建后校验产物数量，不足则清缓存重试；重试后正常，仍不足则让构建失败，避免发布缺文章的镜像。
RUN src=$(ls src/content/posts/*.md | wc -l); \
    attempt=0; \
    while :; do \
      attempt=$((attempt+1)); \
      npm run build; \
      got=$(ls dist/posts | wc -l); \
      if [ "$got" = "$src" ]; then echo "OK: $got/$src posts built (attempt $attempt)"; break; fi; \
      if [ "$attempt" -ge 5 ]; then echo "FAIL: only $got/$src posts after $attempt attempts"; exit 1; fi; \
      echo "WARN: attempt $attempt built $got/$src posts, retrying"; \
      rm -rf dist .astro; \
    done

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
# 删除镜像内的 view-counts.json 模板，必须依赖 bind mount 注入真实数据
# 否则容器会返回过时的模板数据（全 0），即使服务器 daemon 已写入真实数据
RUN rm -f /usr/share/nginx/html/view-counts.json
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
