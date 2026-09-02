FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
# 删除镜像内的 view-counts.json 模板，必须依赖 bind mount 注入真实数据
# 否则容器会返回过时的模板数据（全 0），即使服务器 daemon 已写入真实数据
RUN rm -f /usr/share/nginx/html/view-counts.json
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
