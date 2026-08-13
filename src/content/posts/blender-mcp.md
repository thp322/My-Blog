---
title: 如何让 Blender 接入 Claude Code, 实现全自动建模？
date: 2026-08-12
tags: [Blender, Claude, MCP]
description: Blender 接入 Claude，实现全自动建模：告别手动调参的 AI3D 创作实战
---

Blender-MCP 通过模型上下文协议将 Blender 与 Claude Code 连接在一起，使得 Claude 能够直接与 Blender 进行交互和控制，实现了基于提示的 3D 建模、场景创建以及操作功能。下面博主整理了 GitHub 和 YouTube 上面的官方教程，手把手教你开始自己的 AI3D。

---

## 1.软件安装列表

在开始之前，需要安装好以下软件：

### 前置安装列表

| 软件名 | 版本要求 | 官方网址 |
| :--- | :--- | ---- |
| Blender | 3.0 或更高版本 | [Blender](https://www.blender.org/download/)           |
| Python | 3.10 或更高版本 | [Python](https://www.python.org/downloads/) |
| UV 包管理器 | —— | ——                                                     |
| Claude Desktop | —— | [Claude](https://claude.com/product/claude-code)       |
| Blender-MCP | —— | [Blender-MCP](https://github.com/ahujasid/blender-mcp) |

### 官方教程

官方视频教程：[YouTube](https://www.youtube.com/watch?v=lCyQ717DuzQ)

官方指导文档：[Blender-MCP](https://blendermcp.org/setup/claude)

## 2.安装教程

### 2.1.Blender-MCP

进入官方网址下载 .zip 文件并：

![1](/images/Blender-MCP/1.png)

解压 .zip 文件，打开解压后的文件进入含 addon.py 的文件夹，并且复制文件路径：

![2](/images/Blender-MCP/2.png)

### 2.2.UV 包

不同操作系统安装 UV 包的方法：

#### Windows

```powershell
powershell -c "irm https://astral.sh/uv/install.ps1 | iex" 
```

然后将 UV 文件添加到 Windows 系统的用户路径中（之后可能需要重新启动 Claude 桌面应用程序）

```powershell
$localBin = "$env:USERPROFILE\.local\bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
[Environment]::SetEnvironmentVariable("Path", "$userPath;$localBin", "User")
```

#### Mac

```
brew install uv
```

确定安装成功：

```
uv --version
```

#### 完整文档（可选）

完整的 uv 安装文档：[uv](https://docs.astral.sh/uv/getting-started/installation/)

## 3.配置 Blender 

进入 Blender，点击左上角 Edit，依次点击 Preferences  >>  Add-ons 进入如下页面：

![3](/images/Blender-MCP/3.png)

点击 Install from Disk... 后将前面复制的文件路径粘贴，选择 `addon.py` 

![4](/images/Blender-MCP/4.png)

点击 Install from Disk

回到主页面，按键盘的 “N” 键，右上键会多一个 BlenderMCP ，点击它:

![5](/images/Blender-MCP/5.png)

使用默认端口，点击连接即可：

![6](/images/Blender-MCP/6.png)

## 4.配置 Claude 桌面客户端

进入 Claude Desktop 设置界面，点击 Developer，点击 Edit Config：

![7](/images/Blender-MCP/7.png)

找到 `claude_desktop_config.json` 文件，添加 Blender MCP 服务器的相关信息：

```json
{
  "mcpServers": {
    "blender": {
      "command": "uvx",
      "args": ["blender-mcp"]
    }
  }
}
```

> [!NOTE]
>
> **配置文件在哪儿？**
>
> - **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json` 
> - **Windows:** `%APPDATA%\Claude\claude_desktop_config.json` 

如果你更喜欢使用 Claude Code CLI，那么可以通过一个命令来添加 MCP 服务器：

```
claude mcp add blender uvx blender-mcp
```

保存该文件后，重新启动 Claude Desktop，以使更改生效。

再次点击设置界面的 Developer，如果看到以下内容则代表安装成功：

![8](/images/Blender-MCP/8.png)

## 5.使用 Claude 制作你的第一个 3D 模型

打开 Claude Desktop，可以按照以下提示词进行测试：

- “Create a low poly dungeon scene with a dragon guarding a pot of gold”

  “创建一个低多边形风格的地下城场景，其中有一只龙守护着一口金罐子。”

- “Create a beach vibe using HDRIs and models from Poly Haven”

  “利用 HDRIs 和 Poly Haven 中的模型来打造一种海滩氛围”

- “Make a red metallic sphere floating above a blue cube”

  “创造一个红色金属球体，悬挂在蓝色立方体之上”

- “Set up studio lighting and point the camera at the scene with an isometric view”

  “设置工作室照明，并将相机对准场景，采用立体视角进行拍摄。”

- “Generate a 3D model of a garden gnome through Hyper3D”

  通过 Hyper3D 生成一个花园里的小矮人的 3D 模型。

发送消息后会提示连接 Blender 确认，点击允许即可：

![9](/images/Blender-MCP/9.png)

Claude 可以创建物体、应用材质、设置照明效果、下载 Poly Haven 的素材，通过 Hyper3D Rodin 生成 3D 模型，甚至可以在 Blender 中执行任意的 Python 代码。
