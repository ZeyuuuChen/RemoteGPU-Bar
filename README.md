# RemoteGPU-Bar

> An extremely lightweight, zero-deployment macOS menu bar widget used to monitor NVIDIA GPU status on remote servers via SSH.

RemoteGPU-Bar is a **SwiftBar** plugin written in **Shell**. It connects to your Linux server via SSH, executes `nvidia-smi`, and renders a clean GPU summary in the macOS menu bar and dropdown.

---

## ✨ Features

- **Zero dependencies (server-side)**: only **SSH** + `nvidia-smi` required
- **At a glance**: menu bar shows free GPUs (e.g. `GPU: 2/4 Free`)
- **Detailed dropdown**: per-GPU name, memory usage, utilization
- **Smart coloring**: idle 🟢 vs busy 🔴
- **Perfect alignment**: monospaced layout (Menlo)
- **Quick terminal**: one-click open SSH terminal
- **Multi-server support**: configure multiple servers and switch in dropdown (selection persisted locally)

---

## 📸 Screenshot

See `screenshot.png` in this repo.

---

## ✅ Prerequisites

1. **macOS**
2. **SwiftBar** installed
3. **Passwordless SSH login** from your Mac to the server(s)
4. Remote server(s) have **NVIDIA driver** and `nvidia-smi` available

Test:

```bash
ssh user@your_server_ip
````

If you can log in without a password prompt, you’re good.

---

## 📥 Installation

1. Download `gpu_monitor.1m.sh`
2. Open SwiftBar → menu bar icon → **Open Plugin Folder...**
3. Move `gpu_monitor.1m.sh` into the plugin folder
4. Grant execute permission:

```bash
chmod +x ~/Documents/SwiftBar/gpu_monitor.1m.sh
```

> Note: `.1m.` means refresh every 1 minute. You can change it by renaming the file (e.g. `.30s.` / `.5m.`).

---

## ⚙️ Configuration (Multi-Server / Single-Server)

Open `gpu_monitor.1m.sh` using VSCode / Sublime / `nano`. **Do not use TextEdit**.

### 1) Configure servers

Edit the configuration section at the top and set `SERVERS`.

**Format**

* `"display_name|user@host|/absolute/path/to/private_key"`

**Example (multiple servers)**

```bash
SERVERS=(
  "Lab-A|user@10.0.0.10|/Users/YOUR_USERNAME/.ssh/id_ed25519"
  "Lab-B|user@10.0.0.11|/Users/YOUR_USERNAME/.ssh/id_ed25519"
)
```

**Example (single server)**

```bash
SERVERS=(
  "Main|user@your_server_ip|/Users/YOUR_USERNAME/.ssh/id_ed25519"
)
```

### 2) Switch server in SwiftBar

After saving, click the SwiftBar dropdown:

* Find the **Server** section
* Click a server item to switch
* The selection will be persisted locally so refresh/relaunch keeps your choice

### 3) Why only fetch one server per refresh?

To keep the plugin lightweight and avoid creating **N SSH connections per interval**, each refresh checks **only the currently selected server**. Switch servers via the dropdown when needed.

---

## ❓ FAQ

### Q: Menu bar shows `GPU: Offline`?

SSH failed. Check:

* Network connectivity
* `SERVERS` entries are correct (`user@host` + key path)
* Host key verification: SSH once manually and accept fingerprint:

```bash
ssh user@your_server_ip
# type "yes" if asked
```

### Q: Why is some text in the menu gray?

SwiftBar renders non-interactive items in gray. This script uses interactive attributes (like `refresh=true` / `shell=...`) to keep menu items properly highlighted. If you still see gray text, make sure you’re running the latest script and didn’t remove those attributes.

### Q: How do I change refresh frequency?

Rename the file:

* `gpu_monitor.1m.sh` → `gpu_monitor.30s.sh` (every 30s)
* `gpu_monitor.1m.sh` → `gpu_monitor.5m.sh` (every 5m)

Recommendation: avoid very short intervals (e.g. <10s), as it creates frequent SSH connections.

### Q: How to use with Slurm clusters?

Slurm login/head nodes often have no GPUs. You can adapt the script to call Slurm commands instead of `nvidia-smi`, e.g.:

* `squeue -u $USER` (your jobs)
* `sinfo` (cluster partitions / availability)

---

## 📝 License

MIT License © 2026 zeyu

---

# RemoteGPU-Bar（中文说明）

> 一个极其轻量、无需服务器端部署的 macOS 菜单栏小组件，用于通过 SSH 监控远程服务器的 NVIDIA GPU 状态。

RemoteGPU-Bar 是一个基于 Shell 的 **SwiftBar 插件**：通过 SSH 连接到 Linux 服务器，执行 `nvidia-smi`，并把结果显示在 macOS 菜单栏与下拉菜单中。

---

## ✨ 特点

* **零依赖（服务器端）**：只需要 SSH + `nvidia-smi`
* **一目了然**：菜单栏常驻显示空闲 GPU 数量（例如 `GPU: 2/4 Free`）
* **详细信息**：下拉展示每张卡的名称、显存占用、利用率
* **智能着色**：空闲 🟢 / 忙碌 🔴
* **等宽对齐**：Menlo 字体整齐美观
* **快捷终端**：一键打开 SSH 终端
* **多服务器支持**：配置多台服务器，下拉菜单切换（选择会本地持久化）

---

## ✅ 前置要求

1. macOS
2. 已安装 SwiftBar
3. 已配置 **SSH 免密登录**
4. 远程服务器已安装 NVIDIA 驱动且可用 `nvidia-smi`

测试：

```bash
ssh user@your_server_ip
```

---

## 📥 安装步骤

1. 下载 `gpu_monitor.1m.sh`
2. SwiftBar → 菜单栏图标 → **Open Plugin Folder...**
3. 把脚本放入插件目录
4. 赋予执行权限：

```bash
chmod +x ~/Documents/SwiftBar/gpu_monitor.1m.sh
```

> 文件名中的 `.1m.` 表示 1 分钟刷新一次，可通过重命名修改刷新频率（例如 `.30s.`、`.5m.`）。

---

## ⚙️ 配置方法（多服务器 / 单服务器）

使用 VSCode / Sublime / 终端 `nano` 打开 `gpu_monitor.1m.sh`（不要用系统自带文本编辑器）。

### 1）配置服务器列表

在脚本顶部配置 `SERVERS`。

**格式**

* `"显示名|user@host|私钥绝对路径"`

**示例（多服务器）**

```bash
SERVERS=(
  "Lab-A|user@10.0.0.10|/Users/你的用户名/.ssh/id_ed25519"
  "Lab-B|user@10.0.0.11|/Users/你的用户名/.ssh/id_ed25519"
)
```

**示例（单服务器）**

```bash
SERVERS=(
  "Main|user@your_server_ip|/Users/你的用户名/.ssh/id_ed25519"
)
```

### 2）在 SwiftBar 下拉菜单切换服务器

保存脚本后，点击菜单栏图标：

* 找到 **Server** 区域
* 点击目标服务器即可切换
* 选择会**本地持久化**，刷新/重启后仍保持上次选择

### 3）为什么每次刷新只查询一台服务器？

为了避免每分钟对 N 台服务器建立 N 次 SSH 连接，脚本每次刷新只查询**当前所选服务器**。如需看其他服务器，直接在菜单中切换即可。

---

## ❓ 常见问题（FAQ）

### Q：菜单栏显示 `GPU: Offline`？

SSH 失败。请检查：

* 网络是否可达
* `SERVERS` 中的 `user@host` 与私钥路径是否正确
* 是否需要先手动 SSH 一次接受主机指纹：

```bash
ssh user@your_server_ip
# 若提示则输入 yes
```

### Q：为什么菜单里有些字是灰色的？

SwiftBar 会把不可交互的菜单项渲染成灰色。脚本通过 `refresh=true` / `shell=...` 等交互属性来避免灰字。若仍出现灰字，请确认你使用的是最新脚本且没有删除这些交互属性。

### Q：如何修改刷新频率？

通过重命名脚本：

* `gpu_monitor.1m.sh` → `gpu_monitor.30s.sh`（30 秒刷新）
* `gpu_monitor.1m.sh` → `gpu_monitor.5m.sh`（5 分钟刷新）

建议不要低于 10 秒，以免造成过多 SSH 连接压力。

### Q：如何适配 Slurm 集群？

Slurm 登录节点通常没有 GPU。可以把脚本里的 `nvidia-smi` 替换为 Slurm 命令，例如：

* `squeue -u $USER`（查看自己的任务）
* `sinfo`（查看集群分区/资源概况）

---

## 📝 License

MIT License © 2026 zeyu