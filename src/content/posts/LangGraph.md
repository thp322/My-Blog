---
title: LangGraph 智能体开发 —— 从简单 Chain 到企业级复杂 Agent 工作流
date: 2026-09-07
tags: [RAG, Agent, LangGraph]
description: 详解 LangChain 进阶核心：状态编排、分支循环、人机介入与多智能体实战落地
---

LangChain 链式开发能够快速搭建基础 RAG 与简单对话智能体，但无法满足企业复杂、多步骤、带分支判断、需状态留存的真实业务场景。真实企业 Agent 需要自主任务规划、循环迭代推理、条件分支路由、断点续跑与人工审核介入能力。

**LangGraph 作为 LangChain 生态的高阶编排框架**，补齐了传统线性 Chain 的短板，以状态图模型驱动智能体运行，是构建生产级、可落地、可迭代企业 AI Agent 的核心技术。

本文从原理到实战，完整讲解 LangGraph 核心机制、状态管理、节点与边逻辑、Agent 循环推理范式，手把手带你从入门 Chain 开发，进阶到工业级智能体应用开发。

---

## 一、LangGraph 简介

### 1、为什么 LangGraph 是 AI 开发者的必修课？

AI Agent 已成下一代应用范式，LangGraph 是 Agent 的“操作系统”

- Agent：下一代应用范式
- Runtime：可靠持久化，执行引擎
- HITL：人机协同，生产级能力

$$
LangGraph  = 高层 Agent 抽象(create-agent)
$$

$$
LangGraph = 底层执行引擎与 Agent Runtime
$$

### 2、LangGraph vs LangChain 定位对比

各司其职，协同构建 AI Agent 应用

| 对比维度 | LangChain             | LangGraph                      |
| -------- | --------------------- | ------------------------------ |
| 定位     | Agent 高层开发框架    | 底层编排框架 & Agent Runtime   |
| 核心入口 | create_agent          | StateGraph / @entrypoint       |
| 适用场景 | 结构直接的 Agent 应用 | 复杂工作流、持久化、长时间运行 |
| 流程控制 | Agent 循环自动管理    | 精细控制节点、边、条件分支     |
| 学习成本 | 较低                  | 较高（但能力上限更高）         |

大多数项目从 LangChain 的 create_agent 开始；需要复杂编排时引入 LangGraph

## 二、环境配置

### 1、安装依赖

**LangGraph 全家桶：**

| 包名                            | 用途                         |
| :------------------------------ | :--------------------------- |
| `langgraph`                     | LangGraph 核心库，构建状态图 |
| `langgraph-prebuilt`            | 预置的 Agent 组件            |
| `langgraph-checkpoint`          | 检查点（Checkpoint）机制     |
| `langgraph-checkpoint-postgres` | PostgreSQL 持久化检查点      |
| `langgraph-sdk`                 | LangGraph Python SDK         |

**LangChain 全家桶：**

| 包名                  | 用途                  |
| :-------------------- | :-------------------- |
| `langchain`           | LangChain 核心        |
| `langchain-core`      | LangChain 基础抽象    |
| `langchain-community` | 社区集成              |
| `langchain-openai`    | OpenAI 集成           |
| `langchain-deepseek`  | DeepSeek 集成         |
| `langchain-anthropic` | Anthropic Claude 集成 |

**模型服务商 SDK：**

| 包名                      | 用途                    |
| :------------------------ | :---------------------- |
| `openai`                  | OpenAI 官方 SDK         |
| `anthropic`               | Anthropic 官方 SDK      |
| `dashscope`               | 阿里百炼（Qwen 等模型） |
| `tencentcloud-sdk-python` | 腾讯云 SDK              |

**其他重要依赖：**

| 包名                     | 用途                         |
| :----------------------- | :--------------------------- |
| `fastapi` / `uvicorn`    | Web 服务框架，部署时使用     |
| `pydantic`               | 数据校验，状态定义时大量使用 |
| `httpx` / `httpx-sse`    | HTTP 客户端 + SSE 流式支持   |
| `loguru`                 | 日志库                       |
| `python-dotenv`          | 读取 `.env` 环境变量文件     |
| `tiktoken`               | OpenAI 的 token 计数工具     |
| `SQLAlchemy` / `psycopg` | 数据库操作，持久化时使用     |
| `pymilvus`               | Milvus 向量数据库客户端      |

## 2. 配置 API Key

在这里我们使用 **DeepSeek** 大模型，需要配置 DeepSeek 的 API Key

### 获取 DeepSeek API Key

1. 打开 DeepSeek 开放平台：https://platform.deepseek.com/
2. 注册 / 登录账号
3. 进入 **API Keys** 页面，点击 **创建 API Key**
4. 复制生成的 key（形如 `sk-xxxxxxxx`），注意 key **只显示一次**，请立即保存

### 创建 .env 文件

为了不与之前我们配置的千问大模型 api 冲突，我们在项目根目录下新建 `.env` 文件，填入以下内容：

```
# ============================================
# 使用 DeepSeek 模型
# ============================================
DEEPSEEK_API_KEY=sk-你的DeepSeek_API_Key

# ============================================
# 可选：其他模型服务商（如需切换模型时使用）
# ============================================
# OPENAI_API_KEY=sk-你的OpenAI_API_Key
# ANTHROPIC_API_KEY=sk-ant-你的Anthropic_API_Key

# ============================================
# 部署时需要
# ============================================
# LANGSMITH_API_KEY=lsv2-pt-你的LangSmith_API_Key
# LANGSMITH_TRACING=true
# LANGSMITH_ENDPOINT=https://api.smith.langchain.com
# LANGSMITH_PROJECT="langgraph-tutorial"
```

> `.env` 文件已在 `.gitignore` 中排除，**不会被提交到 Git**，可以放心保存密钥。

### 代码中如何读取 .env

```python
from dotenv import load_dotenv
load_dotenv(override=True)
```

之后创建模型客户端时，SDK 会自动从环境变量中读取对应的 API Key，无需在代码中硬编码：

```
from langchain_deepseek import ChatDeepSeek

# API Key 自动从 DEEPSEEK_API_KEY 环境变量读取
model = ChatDeepSeek(model="deepseek-v4-flash")
```

## 三、LangGraph 总览

LangGraph 运行时底层基于自研的 Pregel 运行时，其核心思想借鉴了 Google Pregel 计算模型，用于组织和执行复杂的图计算流程

















