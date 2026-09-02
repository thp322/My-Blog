---
title: RAG 与 Agent 基础 —— LangChain 开发
date: 2026-09-02
tags: [RAG, Agent]
description: 介绍
---

在。

---

## 一、RAG 与 Agent

### 1、RAG 与 Agent 介绍



### 2、企业核心需求（技术人员拿高薪的核心抓手）

- 怎么能输出精准结果？
- 怎么能对接企业内部数据？
- 怎么能完成复杂任务？

### 3、大模型的短板

- 无法获取最新文档、行业动态
- 直接提问容易出错

### 4、RAG 的优势

- 企业私域数据和大模型结合
- 让大模型**读得懂**专属数据、输出结果**准确贴合**

### 5、Agent 的优势

- 企业的需求不是单次提问、回答，而是需要大模型像虚拟员工一样，自动拆解复杂的任务、一步步执行。比如自动整理会议纪要、完成市场调研、处理咨询流程等，这也是大模型从工具升级为生产力的关键

### 6、用什么框架开发？

- `LangChain`

## 二、前置准备-大模型的接入

### 1、云端大模型

以[阿里云百炼平台](https://bailian.console.aliyun.com/cn-beijing?tab=home#/home)为例：

#### 实名认证

进入主页后登陆、实名认证

#### 创建 API key

点击模型 —> API key，创建 API key，记得复制 API key

点击模型用量可以查看剩余额度，阿里云百炼平台会赠送额外额度，如果不想额外计费，记得打开“免费额度用完即停”

#### 安装 OpenAI 库

在编写代码前我们还需要安装 OpenAI 库：

```shell
pip install openai
```

通过代码调用云端大模型：回到阿里云百炼平台，点击模型广场，任意选择一款模型

#### 测试代码

以 **Qwen3.8-Max** 为例，点击该模型，查看 **API 代码示例**，复制代码到 PyCharm：

```python
from openai import OpenAI
import os

client = OpenAI(
    # 如果没有配置环境变量，请用阿里云百炼API Key替换：api_key="sk-xxx"
    api_key=os.getenv("DASHSCOPE_API_KEY"),
    base_url="https://ws-mz1exca911jor8vw.cn-beijing.maas.aliyuncs.com/compatible-mode/v1",
)

messages = [{"role": "user", "content": "你是谁"}]
completion = client.chat.completions.create(
    model="qwen3.8-max",  # 您可以按需更换为其它深度思考模型
    messages=messages,
    extra_body={"enable_thinking": True},
    stream=True
)
is_answering = False  # 是否进入回复阶段
print("\n" + "=" * 20 + "思考过程" + "=" * 20)
for chunk in completion:
    if not chunk.choices:
        continue
    delta = chunk.choices[0].delta
    if hasattr(delta, "reasoning_content") and delta.reasoning_content is not None:
        if not is_answering:
            print(delta.reasoning_content, end="", flush=True)
    if hasattr(delta, "content") and delta.content:
        if not is_answering:
            print("\n" + "=" * 20 + "完整回复" + "=" * 20)
            is_answering = True
        print(delta.content, end="", flush=True)
```

将 `api_key=os.getenv("DASHSCOPE_API_KEY")` 中的 `DASHSCOPE_API_KEY` 替换为刚才复制的 API-Key，运行测试的代码即可

除了官网给出的示例代码，我们还可以用以下精简的代码测试：

```python
from openai import OpenAI

client = OpenAI(
    api_key=os.getenv("DASHSCOPE_API_KEY"),
    base_url="https://ws-mz1exca911jor8vw.cn-beijing.maas.aliyuncs.com/compatible-mode/v1",
)
completion = client.chat.completions.create(
    model="qwen3.8-max",  
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "你是谁，能做什么？"},
    ],
    stream=True
)
for chunk in completion:
    print(chunk.choices[0].delta.content, end="", flush=True)
```

### 2、使用环境变量保护 API- Key

在上述代码中，将 API-Key 明文直接写在代码中有很大的隐患。我们可以通过环境变量隐藏 API-Key

需要配置两个 API-Key：

- `OPENAI_API_KEY`：用于 openai 库，记录 API-Key
- `DASHSCOPE_API_KEY`：用于 langchain ，后续会用到

#### Windows 配置环境变量方法

点击 win + s 打开搜索框，搜索“高级系统设置”，点击进入，

![1](/images/RAG_Agent/1.png)

点击“环境变量”，在“用户变量”中点击“新建”，分别添加以下环境变量：

| 变量名（N）       | 变量值（Y）       |
| ----------------- | ----------------- |
| OPENAI_API_KEY    | （复制的API-Key） |
| DASHSCOPE_API_KEY | （同上）          |

重启电脑，将代码中的 `api_key=os.getenv("DASHSCOPE_API_KEY")` 删除，运行测试代码：

```python
from openai import OpenAI

client = OpenAI(
    base_url="https://ws-mz1exca911jor8vw.cn-beijing.maas.aliyuncs.com/compatible-mode/v1",
)
completion = client.chat.completions.create(
    model="qwen3.8-max",  
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "你是谁，能做什么？"},
    ],
    stream=True
)
for chunk in completion:
    print(chunk.choices[0].delta.content, end="", flush=True)
```

#### Mac  配置环境变量方法

```shell
open .zshrc
```

回车进入，**不要修改原有内容**，在空白处输入：

```shell
export OPENAI_API_KEY="......"
export DASHSCOPE_API_KEY="......"
```

点击文件 —> 存储

重启电脑

运行测试代码

### 3、本地部署大模型

#### Ollama 简介

- ollama：是一款旨在简化大型语言模型本地部署和运行过程的开源软件
- ollama 提供了一个轻量级、易于扩展的框架，让开发者能够在本地机器上轻松构建和管理 LLMs （大型语言模型）
- 通过 ollama，开发者可以导入和定制自己的模型，无需关注复杂的底层实现细节
- ollama 网址：https://ollama.com
- 简单来说，ollama 可以在本地电脑上部署和运行大模型，由自己电脑的硬件提供算力支撑模型运行
- ollama 支持多种开源模型，涵盖文本生成、代码生成、多模态推理等场景。用户可以根据需求选择合适的模型，并通过简单的命令行操作在本地运行
- ollama 官方模型库：https://ollama.com/library

![2](/images/RAG_Agent/2.png)

#### Ollama 的调用

##### 命令行访问

```shell
ollama run deepseek-r1:1.5b
```

##### Restful API 接口访问

![3](/images/RAG_Agent/3.png)

#### Ollama 的部署

进入官网点击 **Download** 下载安装

打开 ollama，右下角可以选择模型，第一次对话时会下载选定的模型

![4](/images/RAG_Agent/4.png)

可以看到很多模型后面带有“：...b”，这是因为 ollama 中运行的模型都是蒸馏模型，并不是完整版的模型，“...b”就是参数量，可以根据自己电脑的配置选择参数量合适的模型

模型运行时会消耗自己电脑的硬件能力

![5](/images/RAG_Agent/5.png)

#### 代码调用 Ollama 本地模型

只需在调用云端大模型的测试代码中改动 `base_url` 和 `model` 即可:

- `base_url`：改为 http://lacalhost:11434/v1
- `model` ：改为本地下载的模型名称，如 qwen3:4b

```python
from openai import OpenAI

client = OpenAI(、
    base_url="http://lacalhost:11434/v1",
)
completion = client.chat.completions.create(
    model="qwen3:4b",  
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "你是谁，能做什么？"},
    ],
    stream=True
)
for chunk in completion:
    print(chunk.choices[0].delta.content, end="", flush=True)
```

## 三、OpenAI 库的基础使用

OpenAI 库是 OpenAI 官方推出的 python SDK，核心作用是让开发者能简单、高效地调用 OpenAI 的各类 API（如 GPT 聊天、DALL · E 绘图、语音转文字等），无需手动处理 HTTP 请求、身份验证等底层细节

由于其发布较早且比较易用，现如今许多模型服务商（如阿里云百炼平台）均兼容 OpenAI SDK 的调用

OpenAI 库的使用流程

- 获取客户端对象
- 调用模型
- 处理结果

### 获取客户端对象

```python
from openai import OpenAI

client:OpenAI = OpenAI(
	api_key = "......"
    base_url = "......"
)
```

### 调用模型

```python
from openai.types.chat.chat_completion import ChatCompletion

response:ChatCompletion = client.chat.completions.create(
	model = "qwen3-max"
    messages = [
        {"role": "system", "content": "你是一个 python 编程专家。"}，
        {"role": "assistant", "content": "我是一个 python 编程专家。请问有什么可以帮助您的吗？"}，
        {"role": "user", "content": "for 循环输出 1 到 5 的数字。"}
    ]
)
```

`client.chat.completions.create` 创建 ChatCompletion 对象，主要参数有 2 个：

- `model`：选用模型
- `messages`：提供给模型的消息，类型为 list，可以包含多个字典消息，每个字典消息包含 2 个 key ，role 为角色，content 为内容

`role 角色`：

- system：设定助手的整体行为、角色和规则，为对话提供上下文框架（如指定助手身份、回答风格、核心要求），是全局的背景设定，影响后续所有交互
- assistant：代表 AI 助手的回答，可以在代码中人为设定
- user：代表用户，发送问题、指令或需求

### 处理结果

模型的回复为 response 变量，是一个 ChatCompletion 对象，其为类 json 格式，包含的信息如下：

```python
{
"id": "chatcmpl-xxxx",
"object": ,
"created": 17......,
"model": "gpt-3.5-turbo-0125",
"choices": [
    {
        "index": 0,
        "message": {
            "role": "assistant",
            "content": "生成的回复内容"
        },
        "finish_reason": "stop"  # stop=正常，length=令牌数超额，function_call=触发函数调用
    }
],
"usage": {
    "prompt_tokens": 50,
    "completion_tokens":80,
    "total_tokens": 130
}
}
```

可以通过如下输出模型给出的回答信息：

```python
print(response.choices[0].message.content)
```

### 完整代码

```python
from openai import OpenAI

# 1,获取 client 对象，OpenAI 类对象
client = OpenAI(
	# 设置了环境变量，这里不用再写 api_key
    base_url = "https://ws-mz1exca911jor8vw.cn-beijing.maas.aliyuncs.com/compatible-mode/v1"
)

# 2,调用模型
response = client.chat.completions.create(
	model = "qwen3-max",
    messages = [
        {"role": "system", "content": "你是一个 python 编程专家。"}，
        {"role": "assistant", "content": "我是一个 python 编程专家。请问有什么可以帮助您的吗？"}，
        {"role": "user", "content": "for 循环输出 1 到 5 的数字。"}
    ]
)

# 3,处理结果
print(response.choices[0].message.content)
```

### 流式输出

可以设定结果输出为 stream 模式（流式输出），获得更好的使用体验

开启流式输出步骤：

- 在 `client.chat.completions.create()` 调用模型时设定参数：`stream = True`
- for 循环 response 对象，并在循环内输出内容

```python
from openai import OpenAI

# 1,获取 client 对象，OpenAI 类对象
client = OpenAI(
	# 设置了环境变量，这里不用再写 api_key
    base_url = "https://ws-mz1exca911jor8vw.cn-beijing.maas.aliyuncs.com/compatible-mode/v1"
)

# 2,调用模型
response = client.chat.completions.create(
	model = "qwen3-max",
    messages = [
        {"role": "system", "content": "你是一个 python 编程专家。"}，
        {"role": "assistant", "content": "我是一个 python 编程专家。请问有什么可以帮助您的吗？"}，
        {"role": "user", "content": "for 循环输出 1 到 5 的数字。"}
    ],
    stream = True   # 开启流式输出
)

# 3,处理结果
# print(response.choices[0].message.content)
for chunk in response:
    if chunk.choices[0].delta.content:
        print(
            chunk.choices[0].delta.content, 
            end=" ",     # 不要以回车符结尾
            flush=True   # 立刻刷新缓冲区
        )
```

### 附带历史消息

调用模型传入的参数 messages，其要求是 list 对象，即表明其支持非常多的消息在内

基于此，将历史消息填入，让模型知晓对话的上下文，更好的回答

```python
from openai import OpenAI

client = OpenAI(
    base_url = "https://ws-mz1exca911jor8vw.cn-beijing.maas.aliyuncs.com/compatible-mode/v1"
)

response = client.chat.completions.create(
	model = "qwen3-max",
    messages = [
        {"role": "system", "content": "你是 AI 助理，回答很简洁"},
        {"role": "user", "content": "小明有 2 条宠物狗"},
        {"role": "assistant", "content": "好的"},
        {"role": "user", "content": "小红有 3 只宠物猫"},
        {"role": "assistant", "content": "好的"},
        {"role": "user", "content": "总共有几个宠物？"}
    ],
    stream = True
)

for chunk in response:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end=" ", flush=True)
```

当前的历史消息是一次性的，如果是生产系统可以将消息保存到文件、数据库等持久化工具内，需要的时候提取使用

## 提示词工程

提示工程（Prompt Engineering），也称为 In-Context Prompting，是指在**不更新模型权重**的情况下如何与大模型交互以引导其行为以获得所需结果的方法

- 提示工程 —— 提问的工程
- 在人工智能领域，Prompt 指的是用户给大型语言模型发出的指令
- 虽然看似简单，但实际上，Prompt 的设计对于模型的结果影响很大
- 因此如何设计 Prompt ，进而与模型更好的交互，是研究人员那必备的必不可少的技能（提示工程）

### 提示词技巧

任何 Prompt 技巧，都不如清晰的表达你的需求。类似人与人沟通，如果话说不明白，不可能让别人理解你的思想。因此，写出清晰的指令是核心

- 技巧 1：详细的描述
- 技巧 2：让模型充当某个角色
- 技巧 3：使用分隔符标明输入的不同部分，如用中括号、XML标签、三引号等分隔符可以帮助划分要区别对待的文本，也可以帮助模型更好的理解文本内容。常用''' '''把内容框起来
- 技巧 4：对任务指定步骤
- 技巧 5：提供例子
- 技巧 6：使用参考文本，基于文本文档辅助大模型回答，降低模型**幻觉**问题，是经典的知识库用法，让大模型使用我们提供的信息来组成答案

用更详细、更清晰、有逻辑、有参考的提问，获得期望中的回答效果。不管是 RAG 还是 Agent 智能体亦或是其他围绕模型的各类复杂的开发工作，本质上都可以简单总结为在提示词上下功夫

 提示词优化是所有大模型应用开发的基础必修课，一个好的提示词，甚至能让基础模型的输出效果媲美经过简单微调的模型

### 提示词优化思想

#### Zero-shot 思想

Zero-shot 学习（Zero-shot Learning）是指在训练阶段不存在与测试阶段完全相同的类别，但是模型可以使用训练过的知识来推广到测试集中的新类别上

这种能力被称为“零样本”学习，因为模型在训练时从未见过测试集中的新类别，在**模型训练**和**提示词优化**中均有体现

![6](/images/RAG_Agent/6.png)

#### Few-shot 思想

Few-shot 学习（Few-shot Learning）是指少样本学习，当模型在学习了一定类别的大量数据后，对于新的类别，只需要少量的样本就能快速学习，对应的有 one-shot learning，单样本学习，也算样本少到为一的情况下的一种 few-shot learning

![7](/images/RAG_Agent/7.png)

#### 案例

```python
from openai import OpenAI

client = OpenAI(
    base_url="https://dashscope.aliyuncs.com/compatible-mode/v1"
)

# 示例数据
examples_data = {
    '新闻报道': '今日，股市经历了一轮震荡，受到宏观经济数据和全球贸易紧张局势的影响。投资者密切关注美联储可能的政策调整，以适应市场的不确定性。',
    '财务报告': '本公司年度财务报告显示，去年公司实现了稳步增长的盈利，同时资产负债表呈现强劲的状况。经济环境的稳定和管理层的有效战略执行为公司的健康发展奠定了基础。',
    '公司公告': '本公司高兴地宣布成功完成最新一轮并购交易，收购了一家在人工智能领域领先的公司。这一战略举措将有助于扩大我们的业务领域，提高市场竞争力',
    '分析师报告': '最新的行业分析报告指出，科技公司的创新将成为未来增长的主要推动力。云计算、人工智能和数字化转型被认为是引领行业发展的关键因素，投资者应关注这些趋势'
}

# 分类列表
examples_types = ['新闻报道', '财务报道', '公司公告', '分析师报告']

# 提问数据
questions = [
    "今日，央行发布公告宣布降低利率，以刺激经济增长。这一降息举措将影响贷款利率，并在未来几个季度内对金融市场产生影响。",
    "ABC公司今日发布公告称，已成功完成对XYZ公司股权的收购交易。本次交易是ABC公司在扩大业务范围、加强市场竞争力方面的重要举措。据悉，此次收购将进一步巩固ABC公司在行业中的地位，并为未来业务发展提供更广阔的发展空间。详情请见公司官方网站公告栏",
    "公司资产负债表显示，公司偿债能力强劲，现金流充足，为未来投资和扩张提供了坚实的财务基础。",
    "最新的分析报告指出，可再生能源行业预计将在未来几年经历持续增长，投资者应该关注这一领域的投资机会",
    "小明喜欢小新哟"
]

messages = [
    {"role": "system", "content": "你是金融专家，将文本分类为['新闻报道', '财务报道', '公司公告', '分析师报告']，不清楚的分类为'不清楚类别' 下面有示例："},
]

for key, value in examples_data.items():
    messages.append({"role": "user", "content": value})
    messages.append({"role": "assistant", "content": key})

# 向模型提问
for q in questions:
    response = client.chat.completions.create(
        model="qwen3-max",
        messages=messages + [{"role": "user", "content": f"按照示例，回答这段文本的分类类别：{q}"}]
    )s

    print(response.choices[0].message.content)
```

### Json 数据格式

Json （JavaScript Object Notation）是一种轻量级的数据交换格式，易于人阅读和编写，同时易于机器解析和生成。Json 是带有格式的字符串，主要用于数据交换，即程序和程序之间的信息交互，使用 Json 会更加方便

- Text 文本：非结构化，抽取信息不方便
- CSV（固定分隔符）文本：结构化，抽取信息方便，但是数据不含 Schema，有一定风险（不知道某些数据的含义）
- Json 文本：含 Schema，但空间占用大（空间换安全）

#### Json 的两种结构

- Json 对象：与 python 中的字典没区别
- Json 数组：列表套字典

![8](/images/RAG_Agent/8.png)

Json 在 python 中就是字典与列表套字典的字符串表现形式

#### Python 中使用 Json

python 中使用 Json 主要完成：

- 将 python 字典、列表转换成 Json 字符串
- 读取 Json 字符串，转换成 python 字典或列表

主要使用 python 内置的 Json 库：

- json.dumps（字典或列表，ensure_ascill=False）：将字典或列表转换成 Json 字符串（ensure_ascill=False 确保中文能正常显示，返回值：Json 字符串）
- json.loads（json 字符串）：将 Json 字符串转换为 python 字典或列表（返回值：python 字典或python 列表）

**案例**

python —> json

```python
import json

d = {
    "name": "周杰轮",
    "age": 11,
    "gender": "男"
}

s = json.dumps(d, ensure_ascii=False)
print(s)

# {"name": "周杰轮", "age": 11, "gender": "男"}
```

注意：如果直接用 `s = str(d)` 转化的 `s ` 为 `{'name': '周杰轮', 'age': 11, 'gender': '男'}`，而标准的 Json 数据为了跨语言的通用性，是双引号

```python
import json

l = [
    {
        "name": "周杰轮",
        "age": 11,
        "gender": "男"
    },
    {
        "name": "蔡依临",
        "age": 12,
        "gender": "女"
    },
    {
        "name": "小明",
        "age": 16,
        "gender": "男"
    }
]

print(json.dumps(l, ensure_ascii=False))

# [{"name": "周杰轮", "age": 11, "gender": "男"}, {"name": "蔡依临", "age": 12, "gender": "女"}, {"name": "小明", "age": 16, "gender": "男"}]
```

json —> python

```python
import json

json_str = '{"name": "周杰轮", "age": 11, "gender": "男"}'

res_dict = json.loads(json_str)
print(res_dict, type(res_dict))
```

```python
import json

json_array_str = '[{"name": "周杰轮", "age": 11, "gender": "男"}, {"name": "蔡依临", "age": 12, "gender": "女"}, {"name": "小明", "age": 16, "gender": "男"}]'

res_list = json.loads(json_array_str)
print(res_list, type(res_list))
```



















## 手写笔记

![1](/images/RAG_Agent/1.jpg)

![2](/images/RAG_Agent/2.jpg)

![3](/images/RAG_Agent/3.jpg)

![4](/images/RAG_Agent/4.jpg)

![5](/images/RAG_Agent/5.jpg)

![6](/images/RAG_Agent/6.jpg)

![7](/images/RAG_Agent/7.jpg)

![8](/images/RAG_Agent/8.jpg)

![9](/images/RAG_Agent/9.jpg)

![10](/images/RAG_Agent/10.jpg)

![11](/images/RAG_Agent/11.jpg)
