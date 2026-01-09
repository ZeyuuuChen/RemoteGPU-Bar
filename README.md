# RemoteGPU-Bar 🟢
![icon](icon.png)

> An extremely lightweight, zero-deployment macOS menu bar widget used to monitor NVIDIA GPU status on remote servers via SSH.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)
![Requires](https://img.shields.io/badge/requires-SwiftBar-orange)

**RemoteGPU-Bar** is a [SwiftBar](https://github.com/swiftbar/SwiftBar) plugin based on Shell scripting. It connects to your Linux server via SSH, executes the `nvidia-smi` command, and parses the results into a beautiful, intuitive macOS menu bar display.

---

## ✨ Features

* 🚀 **Zero Dependencies**: No need to install Python, Node.js, or any web services on the server side. Only SSH and `nvidia-smi` are required.
* 👀 **At a Glance**: The menu bar persistently displays the number of idle GPUs (e.g., `GPU: 2/4 Free`).
* 📊 **Detailed Data**: Click the dropdown to show each card's name, memory usage, and utilization rate.
* 🎨 **Smart Coloring**: Idle GPUs are marked with green 🟢, while busy ones are marked with red 🔴.
* 🔤 **Perfect Alignment**: Uses monospaced font (Menlo) to ensure numbers are displayed neatly.
* 🖥️ **Quick Terminal**: One-click to open an SSH terminal connection to the server.

---

## 📸 Screenshot

![Screenshot](screenshot.png)

---

## 🛠 Prerequisites

Before using this plugin, please ensure you meet the following conditions:

1. **macOS**: Your computer is a Mac.
2. **SwiftBar**: Installed [SwiftBar](https://github.com/swiftbar/SwiftBar/releases) (a free and open-source menu bar customization tool).
3. **Passwordless SSH Login**: Your Mac must be configured with SSH key pairs and be able to log in to the target server **without a password**.
    * *Test Method: Type `ssh user@your_server_ip` in the terminal. If you log in successfully without being prompted for a password, you are ready.*

---

## 📥 Installation

1. **Download the Script**:
   Download the `gpu_monitor.1m.sh` file from this repository to your local computer.
   *(Note: The `.1m.` in the filename represents a refresh every 1 minute; you can modify this as needed).*

2. **Add to Plugin Folder**:
   Open SwiftBar, click the menu bar icon -> `Open Plugin Folder...`, and drop the downloaded `.sh` file into that directory.

3. **Grant Execution Permissions**:
   Open your terminal and run the following command (replace the path with your actual plugin directory):
   ```bash
   chmod +x ~/Documents/SwiftBar/gpu_monitor.1m.sh
   ```
 ⚙️ Configuration (Important!)
You need to modify the script file to match your server information.

Open gpu_monitor.1m.sh using a text editor (Recommended: VSCode, Sublime Text, or terminal nano; do not use the default macOS TextEdit).

Modify the configuration area at the top of the script:

```Bash
# ================= CONFIGURATION AREA =================
# 1. Change to your server's SSH username and IP address
HOST="user@your_server_ip"

# 2. Change to the absolute path of your local Mac SSH private key
# Usually ~/.ssh/id_rsa or ~/.ssh/id_ed25519
ID_FILE="/Users/YOUR_USERNAME/.ssh/id_rsa"
# ======================================================
Save the file. SwiftBar will usually detect the change and refresh automatically. You can also manually click the menu bar -> Refresh All.
```

---

## ❓ FAQ
Q: Menu bar shows "GPU: Offline 🔴"? 
A: This means the SSH connection failed. Please check:
Whether your network can connect to the server.
Whether the HOST and ID_FILE paths in the script are correct.
Click the menu to view the red error message details. If it says "Host verification failed," please connect to the server manually once in the terminal and type yes to accept the host fingerprint.

Q: Why is the text in the menu gray? 
A: Ensure you are using the latest version of the script. The script must include interactive attributes like refresh=true or shell=... for macOS to render it in the normal highlight color.

Q: How do I change the refresh frequency? 
A: Change the middle part of the script filename. For example, changing .1m. to .30s. sets the refresh to every 30 seconds. It is recommended not to go below 10s to avoid unnecessary SSH connection pressure on the server.

---

## 📄 License
MIT License © 2026 zeyu  



# RemoteGPU-Bar 🟢[中文说明]

> 一个极其轻量、无需服务器端部署的 macOS 菜单栏小组件，用于通过 SSH 监控远程服务器的 NVIDIA GPU 状态。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)
![Requires](https://img.shields.io/badge/requires-SwiftBar-orange)

**RemoteGPU-Bar** 是一个基于 Shell 脚本的 [SwiftBar](https://github.com/swiftbar/SwiftBar) 插件。它通过 SSH 连接到你的 Linux 服务器，运行 `nvidia-smi` 命令，并将结果解析为美观、直观的 macOS 菜单栏信息。

**特点：**
* 🚀 **零依赖**：服务器端无需安装 Python、Node.js 或任何 Web 服务。只要有 SSH 和 `nvidia-smi` 即可。
* 👀 **一目了然**：菜单栏常驻显示空闲 GPU 数量（例如 `GPU: 2/4 Free`）。
* 📊 **详细数据**：点击下拉展示每张卡的名称、显存占用和利用率。
* 🎨 **智能着色**：空闲显卡显示绿色 🟢，忙碌显卡显示红色 🔴。
* 🔤 **完美对齐**：使用等宽字体 (Menlo)，数字显示整齐治愈。
* 🖥️ **快捷终端**：一键打开 SSH 终端连接到服务器。

---

## 📸 预览截图

![Screenshot](screenshot.png)


---

## 🛠 前置要求

在使用此插件之前，请确保你满足以下条件：

1.  **macOS**: 你的电脑是 Mac。
2.  **SwiftBar**: 已安装 [SwiftBar](https://github.com/swiftbar/SwiftBar/releases) (一个免费开源的菜单栏管理工具)。
3.  **SSH 免密登录**: 你的 Mac 必须配置了 SSH 密钥对，并能**免密码**登录到目标服务器。
    * *测试方法：在终端输入 `ssh user@your_server_ip`，如果不需要输入密码直接登录成功，即满足要求。*

---

## 📥 安装步骤

1.  **下载脚本**：
    将本仓库中的 `gpu_monitor.1m.sh` 文件下载到你的本地电脑。
    *(注意文件名中的 `.1m.` 代表每 1 分钟刷新一次，你可以按需修改)*

2.  **放入插件目录**：
    打开 SwiftBar，点击菜单栏图标 -> `Open Plugin Folder...`，将下载的 `.sh` 文件拖入该目录。

3.  **赋予执行权限**：
    打开终端，运行以下命令（替换为你实际的插件目录路径）：
    ```bash
    chmod +x ~/Documents/SwiftBar/gpu_monitor.1m.sh
    ```

---

## ⚙️ 配置方法 (重要!)

你需要修改脚本文件以匹配你的服务器信息。

使用文本编辑器（推荐 VSCode, Sublime Text 或终端 nano，**不要用自带的文本编辑**）打开 `gpu_monitor.1m.sh`。

修改脚本顶部的配置区域：

```bash
# ================= 配置区域 =================
# 1. 修改为你的服务器 SSH 用户名和 IP 地址
HOST="user@your_server_ip"

# 2. 修改为你 Mac 本地的 SSH 私钥绝对路径
# 通常是 ~/.ssh/id_rsa 或 ~/.ssh/id_ed25519
ID_FILE="/Users/你的用户名/.ssh/id_rsa"
# ===========================================
```
保存文件。SwiftBar 通常会自动检测到更改并刷新，你也可以手动点击菜单栏 -> Refresh All。

---

## ❓ 常见问题 (FAQ)
Q: 菜单栏显示 "GPU: Offline 🔴"？ 
A: 这意味着 SSH 连接失败。请检查：
你的网络能否连接到服务器。
脚本中 HOST 和 ID_FILE 路径是否正确。
点击菜单，查看红色的报错信息详情。如果是 "Host verification failed"，请先在终端手动连接一次服务器并输入 yes 接受主机指纹。

Q: 为什么菜单里的字是灰色的？ 
A: 请确保你使用的是最新版的脚本。脚本中必须包含 refresh=true 或 shell=... 等交互属性，macOS 才会将其渲染为正常的高亮颜色。

Q: 如何修改刷新频率？ 
A: 修改脚本文件名的中间部分。例如，将 .1m. 改为 .30s. 就是 30 秒刷新一次。建议不要低于 10s，以免给服务器造成不必要的 SSH 连接压力。

---

## 📄 License
MIT License © 2026 zeyu
