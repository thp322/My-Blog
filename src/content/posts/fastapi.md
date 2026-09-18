---
title: FastAPI 从入门到实战
date: 2026-09-18
tags: [后端, FastAPI, 中间件, ORM]
description: FastAPI 从简单到入门的教程，涵盖最简单的接口创建、请求参数处理、响应类型，深入讲解中间件原理与应用、依赖注入机制、ORM，以及数据库操作
---

FastAPI 是基于 Python 类型提示的现代高性能 Web 框架，上手简单且性能优异。本文从最基础接口写起，逐步讲解参数处理、响应模型、中间件、依赖注入与 ORM 数据库操作，带你完成 FastAPI 从入门到实战。

---

## 一、FastAPI 介绍

### 前言

fastAPI 是大模型部署的核心能力，利用 fastAPI构建自己的大模型，，并且提供出一个可以访问的地址，供其他应用接入我们的大模型

大模型工程师核心能力：

- python 基础
- 服务化能力：通过 Python Web 框架将模型从本地代码部署为可在线访问、可扩展且稳定运行的服务
- AI 大模型开发能力：模型训练 、构建、微调、优化等

**Python 框架千千万，fastAPI 框架是首选**

| 对比维度 |       FastAPI       |     Flask     |    Django    |
| :------: | :-----------------: | :-----------: | :----------: |
|   性能   |   高（异步支持）    |      中       | 较低（同步） |
| 异步支持 | 内置 async / await  |    需扩展     |    不原生    |
| 数据验证 |  Pydantic 自动校验  |   手动处理    |  ORM 级验证  |
| 自动文档 |      自动生成       |    需插件     |    需扩展    |
| 使用场景 | API、微服务、AI推理 | 小型 Web 项目 |   大型网站   |

### fastAPI 优势

fastAPI 是一个基于 Python 的**高性能** Web 框架，专门用于**快速构建 API 接口服务**，原生异步支持，释放真正性

#### 1、异步支持

让我们模拟一下同步与异步代码：

**同步**

```python
@app.get("/sync")
def func_sync():
    start = time.time()
    for i in range(10):
        time.sleep(1)
    end = time.time()
    return {"time": f'{end-start:.2f}s'}
```

```json
{
    "time": "10.04s"
}
```

![1](/images/fastapi/1.png)

HTTP 请求、数据库、文件写入都是需要等待的 I/O 操作，易造成阻塞

**异步**

```python
@app.get("/async")
async def func_async():
    start = time.time()
    tasks = [asyncio.sleep(1) for i in range(10)]
    await asyncio.gather(*tasks)
    end = time.time()
    return {"time": f'{end-start:.2f}s'}
```

```json
{
    "time": "1.00s"
}
```

![2](/images/fastapi/2.png)

而异步遇到 I/O 操作时会切换任务

#### 2、类型提示与数据验证

Pydantic 类型提示与验证，减少手动校验代码

```python
from pydantic import BaseModel

class User(BaseModel):
    username: str
    password: str

@app.post("/register")
async def register(user: User):
    return user
```

#### 3、可交互式文档

自动生成可交互式文档，浏览器中直接调用和测试 API

![3](/images/fastapi/3.png)

## 二、FastAPI 基础入门

### 1、第一个 FastAPI 程序

#### 创建 FastAPI 项目

new project —> FastAPI —> 创建

![4](/images/fastapi/4.png)

创建完成后自动生成两个文件，其中 `main.py`：

```python
from fastapi import FastAPI

# 创建 FastAPI 实例
app = FastAPI()

# async 修饰的函数会变成异步函数
@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/hello/{name}")
async def say_hello(name: str):
    return {"message": f"Hello {name}"}
```

#### 运行 FastAPI 项目

- 右上角 Run

- 命令行：

  ```cmd
  uvicorn main:app
  ```

  或：

  ```cmd
  # reload 修改代码自动重启服务器。右上角 Run 也是同样的效果
  uvicorn main:app --reload
  ```

#### 查看可交互式文档

浏览器输入：127.0.0.1:8000/docs

点击 **try it out** 可在线调试

###  2、路由

路由就是 URL 地址和处理函数之间的映射关系，它决定了当前用户访问某个特定网址时，服务器应该执行哪段代码来返回结果

fastAPI 的路由定义基于 Python 的装饰器模式

![6](/images/fastapi/6.png)

### 3、参数和路径参数

参数就是客户端发送请求时附带的额外信息和指令 

参数的作用是让同一个接口能根据不同的输入，返回不同的输出，实现动态交互

同一段接口逻辑，根据参数不同返回不同的数据

![7](/images/fastapi/7.png)

参数分类：

![8](/images/fastapi/8.png)

#### （1）路径参数

例子：

```python
# 路径参数
@app.get("/book/{id}")
async def get_book(id: int):
    return {"id": id, "title": f"这是第{id}本书"}
```

##### Path 类型注解 

FastAPI 允许为参数声明额外的信息和校验

需要导入 FastAPI 的 Path 函数

**常用参数：**

|         Path 参数         |              说明               |
| :-----------------------: | :-----------------------------: |
|            ···            |              必填               |
|      gt/ge<br/>le/le      | 大于/大于等于<br/>小于/小于等于 |
|        description        |            参数描述             |
| min_length<br/>max_length |            长度限制             |
|           title           |            参数标题             |

例子：

```python
from fastapi import FastAPI, Path

app = FastAPI()

@app.get("/book/{id}")
async def get_book(id: int = Path(..., gt=0, lt=101, description="书籍id，取值范围1-100")):
    return {"id": id, "title": f"这是第{id}本书"}
```

#### （2）查询参数

声明的参数不是路径参数时，路径操作函数会把该参数自动解释为查询参数

查询参数通过 URL 的 query string 传递（`?key=value`）

例子：

```python
@app.get("/news/news_list")
async def get_news_list(skip: int, limit: int=10):   # limit 默认值为 10
	return {"skip": skip, "limit": limit}
```

##### Query 类型注解 

例子：

```python
@app.get("/news/news_list")
async def get_news_list(
    skip: int = Query(0, description="跳过的记录数", lt=100),
    limit: int = Query(10, description="返回的记录数")
):
    return {"skip": skip, "limit": limit}
```

示例请求：

```
GET /items/?skip=0&limit=10
```

#### （3）请求体参数

请求体参数通过 HTTP 请求体传递，通常使用 JSON 格式，需要定义 Pydantic 模型

在HTTP协议中，一个完整的请求由三部分组成： 

- 请求行：包含方法、URL、协议版本 
- 请求头：元数据信息（Content-Type、Authorization等） 
- 请求体：实际要发送的数据内容

请求体参数写法：

1. 定义类型

   ```python
   from pydantic import BaseModel
   
   class User(BaseModel):
       username: str
       password: str
   ```

2. 类型注解

   ```python
   @app.post("/register")
   async def register(user: User):
   	return user
   ```

   ![9](/images/fastapi/9.png)

##### Field 类型注解 

**注意**：与路径参数和查询参数不同的是，Field 是 pydantic 中的函数，而不是 fastAPI 原生的

例子：

```python
from fastapi import FastAPI, Query
from pydantic import BaseModel, Field

app = FastAPI()

class User(BaseModel):
    username: str = Field(default="张三", min_length=2, max_length=10, description="用户名，长度要求2-10个字")
    password: str = Field(min_length=3, max_length=20)
    
@app.post("/register")
async def register(user: User):
    return user
```

示例请求：

```
POST /items/
{
    "username": "张三",
    "password": "123456",
}
```

### 4、请求与响应

#### HTTP 请求流程

```
客户端请求 → FastAPI 路由匹配 → 参数解析 → 业务处理 → 返回响应 → 客户端接收
```

![10](/images/fastapi/10.png)

默认情况下，FastAPI 会自动将路径操作函数返回的 Python 对象（字典、列表、Pydantic 模型等），经由 jsonable_encoder 转换为  JSON 兼容格式，并包装为 JSONResponse 返回。这省去了手动序列化的步骤，让开发者能更专注于业务逻辑。 如果需要返回非 JSON 数据（如 HTML、文件流)，FastAPI 提供了丰富的响应类型来返回不同数据：

| 响应类型 | 说明 | 示例 |
|---------|------|------|
| `JSONResponse` | JSON 格式响应（默认） | return {"key": "value"} |
| `HTMLResponse` | HTML 格式响应 | return HTMLResponse(html_content) |
| `PlainTextResponse` | 纯文本响应 | return PlainTextResponse("text") |
| `RedirectResponse` | 重定向响应 | return FileResponse(path) |
| `StreamingResponse` | 流式响应（文件下载） | 生成器函数返回数据 |
| `FileResponse` | 文件响应 | return RedirectResponse(url) |
| `ORJSONResponse` | 高性能 JSON 响应 | return ORJSONResponse(content={"msg":"message"}) |

其中`JSONResponse`、`HTMLResponse`、`FileResponse` 较为常用

#### 响应类型设置方式

- 装饰器中指定响应类

  场景：固定返回类型（HTML、纯文本等）

  ```python
  @app.get("/html", response_class=HTMLResponse)
  async def get_html():
  	return "<h1>这是标题</h1>"
  ```

- 返回响应对象

  场景：文件下载、图片、流式响应

  ```python
  @app.get("/file")
  async def get_file():
  	file_path = "./files/1.jpeg"
  	return FileResponse(file_path)
  ```

##### 示例 1：响应 HTML 格式

```python
from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI()

# 装饰器中指定响应类
@app.get("/", response_class=HTMLResponse)
async def read_root():
    html_content = """
    <html>
        <head>
            <title>FastAPI</title>
        </head>
        <body>
            <h1>Hello, FastAPI!</h1>
        </body>
    </html>
    """
    return html_content
```

##### 示例 2：响应文件格式

FileResponse 是 FastAPI 提供的专门用于高效返回文件内容（如图片、PDF、Excel、音视频等）的响应类。它能够智能处理文件路径 、媒体类型推断、范围请求和缓存头部，是服务静态文件的推荐方式

```python
from fastapi import FastAPI
from fastapi.responses import FileResponse

app = FastAPI()

"""
@app.get("/download")
async def download_file():
    return FileResponse(
        path="file.pdf",
        filename="download.pdf",
        media_type="application/pdf"
    )
"""
@app.get("/file")
async def get_file():
    path = "./files/1.jpeg"
    return FileResponse(path)
```

#### 自定义响应（自己写个类）

**response_model** 是**路径操作装饰器**（如 @app.get或 @app.post）的关键参数，它通过一个 **Pydantic 模型来严格定义和约束 API 端 点的输出格式**。这一机制在提供自动数据验证和序列化的同时，更是保障数据安全性的第一道防线

```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

# 需求：新闻接口 → 响应数据格式 id、title、content
class News(BaseModel):
    id: int
    title: str
    content: str

@app.get("/news/{id}", response_model=News)
async def get_news(id: int):
    return {
        "id": id,
        "title": f"这是第{id}本书",
        "content": "这是一本好书"
    }

"""
class CustomResponse(JSONResponse):
    def render(self, content):
        # 自定义响应头
        self.headers["X-Custom-Header"] = "CustomValue"
        return super().render(content)

@app.get("/custom", response_class=CustomResponse)
def get_custom():
    return {"message": "Custom Response"}
"""
```

### 5、异常处理

对于客户端引发的错误（4xx，如资源未找到、认证失败），应使用 `fastapi.HTTPException` 来中断正常处理流程， 并返回标准错误响应

```python
from fastapi import FastAPI, HTTPException
@app.get('/news/{id}')
async def get_news(id: int):
    id_list = [1, 2, 3, 4, 5, 6]
    if id not in id_list:
    	raise HTTPException(status_code=404, detail="当前id不存在")
    return {"id": id}

"""
items = {"foo": "The Foo Wrestlers"}

@app.get("/items/{item_id}")
def read_item(item_id: str):
    if item_id not in items:
        raise HTTPException(
            status_code=404,
            detail="Item not found",
            headers={"X-Error": "There goes my error"}
        )
    return {"item": items[item_id]}
"""
```

自定义异常处理器：

```python
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

app = FastAPI()

class UnicornException(Exception):
    def __init__(self, name: str):
        self.name = name

@app.exception_handler(UnicornException)
async def unicorn_exception_handler(request: Request, exc: UnicornException):
    return JSONResponse(
        status_code=418,
        content={"message": f"Oops! {exc.name} did something. There goes a rainbow..."}
    )

@app.get("/unicorns/{name}")
def read_unicorn(name: str):
    if name == "yolo":
        raise UnicornException(name=name)
    return {"unicorn_name": name}
```

## 三、FastAPI 进阶





















## 1、中间件（Middleware）

### 什么是中间件

中间件是一个函数，它会在每个请求被特定的路径操作处理之前，以及在每个响应返回之前工作。

### 中间件的工作流程

```
请求 → 中间件1 → 中间件2 → ... → 路由处理 → ... → 中间件2 → 中间件1 → 响应
```

### 中间件写法示例

```python
from fastapi import FastAPI, Request

app = FastAPI()

@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    # 请求处理前执行
    start_time = time.time()

    # 调用下一个中间件或路由处理
    response = await call_next(request)

    # 请求处理后执行
    process_time = time.time() - start_time
    response.headers["X-Process-Time"] = str(process_time)

    return response
```

### 中间件常见用途

| 用途       | 说明                  |
| ---------- | --------------------- |
| 请求日志   | 记录所有请求信息      |
| CORS 处理  | 跨域资源共享配置      |
| 身份验证   | 验证 Token 或 Session |
| 响应头添加 | 添加统一的响应头      |
| 性能监控   | 记录请求处理时间      |

---

## 2、依赖注入（Dependency Injection）

### 什么是依赖注入

依赖注入是一种设计模式，允许你声明函数需要哪些依赖，然后由 FastAPI 自动提供这些依赖。

### 依赖注入的应用场景

| 场景       | 说明               |
| ---------- | ------------------ |
| 数据库连接 | 获取数据库会话     |
| 身份验证   | 验证用户身份       |
| 权限检查   | 检查用户权限       |
| 参数校验   | 统一的参数校验逻辑 |
| 日志记录   | 统一的日志处理     |

### 依赖注入基本用法

```python
from fastapi import FastAPI, Depends

app = FastAPI()

# 定义依赖函数
def get_db():
    # 获取数据库连接
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# 在路由中使用依赖
@app.get("/items/")
def read_items(db = Depends(get_db)):
    # db 已经被自动注入
    items = db.query(Item).all()
    return items

# 多个依赖
@app.get("/users/{user_id}")
def read_user(user_id: int, db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    return {"user_id": user_id, "user": current_user}
```

### 带参数的依赖注入

```python
from fastapi import FastAPI, Depends

app = FastAPI()

def common_parameters(q: str = None, skip: int = 0, limit: int = 100):
    return {"q": q, "skip": skip, "limit": limit}

@app.get("/items/")
def read_items(commons: dict = Depends(common_parameters)):
    return commons

@app.get("/users/")
def read_users(commons: dict = Depends(common_parameters)):
    return commons
```

---

## 3、ORM（对象关系映射）

### ORM 简介

ORM（Object-Relational Mapping）是一种技术，它将数据库表映射为编程语言中的对象，使开发者可以使用面向对象的方式操作数据库，而不需要直接写 SQL 语句。

### 常见的 ORM 框架

| 框架             | 语言   | 特点                          |
| ---------------- | ------ | ----------------------------- |
| SQLAlchemy       | Python | 最流行的 Python ORM，功能强大 |
| Django ORM       | Python | Django 自带 ORM，简单易用     |
| Peewee           | Python | 轻量级 ORM，适合小项目        |
| Hibernate        | Java   | Java 生态最流行的 ORM         |
| Entity Framework | .NET   | .NET 官方 ORM                 |

### FastAPI 中的 ORM 使用（以 SQLAlchemy 为例）

#### ORM 使用流程

```
1. 安装依赖 → 2. 创建数据库引擎 → 3. 定义模型类 → 4. 创建表 → 5. CRUD 操作
```

#### 安装依赖

```bash
pip install sqlalchemy
pip install aiomysql  # 如果使用 MySQL
pip install psycopg2-binary  # 如果使用 PostgreSQL
```

#### 创建数据库引擎

```python
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# 数据库连接字符串格式：mysql+pymysql://用户名:密码@主机:端口/数据库名
DATABASE_URL = "mysql+pymysql://root:password@localhost:3306/fastapi_db"

# 创建数据库引擎
engine = create_engine(DATABASE_URL)

# 创建会话工厂
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# 创建基类
Base = declarative_base()

# 获取数据库会话的依赖
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

#### 定义模型类

```python
from sqlalchemy import Column, Integer, String, Float, DateTime
from sqlalchemy.sql import func

class Item(Base):
    __tablename__ = "items"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), nullable=False)
    description = Column(String(300))
    price = Column(Float, nullable=False)
    tax = Column(Float)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, onupdate=func.now())

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    hashed_password = Column(String(100), nullable=False)
    is_active = Column(Integer, default=1)
```

#### 创建数据库表

```python
# 创建所有表
Base.metadata.create_all(bind=engine)

# 或只创建特定表
Item.__table__.create(bind=engine)
```

#### 在路由中使用 ORM

```python
from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

app = FastAPI()

@app.get("/items/")
def get_items(db: Session = Depends(get_db)):
    items = db.query(Item).all()
    return items

@app.get("/items/{item_id}")
def get_item(item_id: int, db: Session = Depends(get_db)):
    item = db.query(Item).filter(Item.id == item_id).first()
    if not item:
        return {"error": "Item not found"}
    return item
```

### ORM 查询操作

#### 基础查询

```python
# 获取所有记录
items = db.query(Item).all()

# 获取第一条记录
item = db.query(Item).first()

# 根据主键获取
item = db.query(Item).get(1)

# 限制数量
items = db.query(Item).limit(10).all()

# 排序
items = db.query(Item).order_by(Item.price).all()
items = db.query(Item).order_by(Item.price.desc()).all()  # 降序
```

#### 条件查询

```python
from sqlalchemy import and_, or_, not_

# 等于
items = db.query(Item).filter(Item.name == "手机").all()

# 不等于
items = db.query(Item).filter(Item.price != 0).all()

# 大于、小于
items = db.query(Item).filter(Item.price > 100).all()
items = db.query(Item).filter(Item.price < 1000).all()

# 大于等于、小于等于
items = db.query(Item).filter(Item.price >= 100).all()
items = db.query(Item).filter(Item.price <= 1000).all()

# IN 查询
items = db.query(Item).filter(Item.name.in_(["手机", "电脑"])).all()

# NOT IN 查询
items = db.query(Item).filter(~Item.name.in_(["手机", "电脑"])).all()

# IS NULL
items = db.query(Item).filter(Item.description == None).all()

# IS NOT NULL
items = db.query(Item).filter(Item.description != None).all()

# AND 条件
items = db.query(Item).filter(and_(Item.price > 100, Item.price < 1000)).all()

# OR 条件
items = db.query(Item).filter(or_(Item.name == "手机", Item.name == "电脑")).all()

# NOT 条件
items = db.query(Item).filter(not_(Item.price == 0)).all()
```

#### 模糊查询

```python
from sqlalchemy import like, ilike

# LIKE（区分大小写）
items = db.query(Item).filter(Item.name.like("%手机%")).all()  # 包含"手机"
items = db.query(Item).filter(Item.name.like("手机%")).all()   # 以"手机"开头
items = db.query(Item).filter(Item.name.like("%手机")).all()   # 以"手机"结尾

# ILIKE（不区分大小写）
items = db.query(Item).filter(Item.name.ilike("%PHONE%")).all()
```

#### 聚合查询

```python
from sqlalchemy import func

# COUNT（计数）
count = db.query(func.count(Item.id)).scalar()
count = db.query(Item).count()

# SUM（求和）
total_price = db.query(func.sum(Item.price)).scalar()

# AVG（平均值）
avg_price = db.query(func.avg(Item.price)).scalar()

# MAX（最大值）
max_price = db.query(func.max(Item.price)).scalar()

# MIN（最小值）
min_price = db.query(func.min(Item.price)).scalar()

# GROUP BY（分组）
from sqlalchemy import GroupBy
results = db.query(Item.name, func.count(Item.id)).group_by(Item.name).all()

# HAVING（分组过滤）
results = db.query(Item.name, func.count(Item.id)).group_by(Item.name).having(func.count(Item.id) > 1).all()
```

#### 分页查询

```python
from sqlalchemy import desc

def get_items(page: int = 1, page_size: int = 10, db: Session = Depends(get_db)):
    # 计算偏移量
    offset = (page - 1) * page_size

    # 查询总数
    total = db.query(Item).count()

    # 分页查询
    items = db.query(Item).order_by(desc(Item.id)).offset(offset).limit(page_size).all()

    return {
        "items": items,
        "total": total,
        "page": page,
        "page_size": page_size,
        "total_pages": (total + page_size - 1) // page_size
    }
```

#### ORM 获取数据总结

```python
# 基本查询
db.query(Model).all()           # 获取所有
db.query(Model).first()         # 获取第一条
db.query(Model).get(id)         # 根据主键获取

# 条件过滤
db.query(Model).filter(Model.field == value).all()
db.query(Model).filter_by(field=value).all()  # 简化写法

# 排序
db.query(Model).order_by(Model.field).all()
db.query(Model).order_by(Model.field.desc()).all()

# 限制数量
db.query(Model).limit(10).all()

# 聚合
db.query(func.count(Model.id)).scalar()
db.query(func.sum(Model.field)).scalar()
```

### ORM 新增操作

```python
# 方式一：创建对象后添加
new_item = Item(name="新商品", price=99.99)
db.add(new_item)
db.commit()
db.refresh(new_item)  # 刷新以获取生成的 ID

# 方式二：直接添加
db.add(Item(name="新商品", price=99.99))
db.commit()

# 批量添加
items = [
    Item(name="商品1", price=99.99),
    Item(name="商品2", price=199.99),
    Item(name="商品3", price=299.99)
]
db.add_all(items)
db.commit()
```

### ORM 更新操作

```python
# 方式一：先查询后更新
item = db.query(Item).filter(Item.id == 1).first()
if item:
    item.name = "更新后的名称"
    item.price = 199.99
    db.commit()
    db.refresh(item)

# 方式二：批量更新
db.query(Item).filter(Item.price < 100).update({"price": 100})
db.commit()

# 方式三：使用 update()
db.query(Item).filter(Item.id == 1).update({
    Item.name: "新名称",
    Item.price: 99.99
})
db.commit()
```

### ORM 删除操作

```python
# 方式一：先查询后删除
item = db.query(Item).filter(Item.id == 1).first()
if item:
    db.delete(item)
    db.commit()

# 方式二：批量删除
db.query(Item).filter(Item.price == 0).delete()
db.commit()

# 方式三：使用 delete()
db.query(Item).filter(Item.id == 1).delete()
db.commit()
```

### ORM 使用注意事项

1. **提交事务**：增删改操作后必须调用 `commit()` 提交事务
2. **刷新对象**：新增后使用 `refresh()` 获取生成的 ID
3. **关闭会话**：使用 `finally` 确保会话被关闭
4. **防止 SQL 注入**：使用 ORM 参数化查询，避免字符串拼接
5. **批量操作**：大量数据使用 `bulk_insert_mappings()` 或 `bulk_update_mappings()` 提高性能
