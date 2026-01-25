#!/bin/bash

# ================= 配置区域 =================
# 格式: "name|user@host|/path/to/id_rsa"
SERVERS=(
  # "server1|user@10.0.0.1|/path/to/id_rsa"
  # "server2|user@10.0.0.2|/path/to/id_rsa"
)
DEFAULT_SERVER_NAME="server1"
# ===========================================

SCRIPT_PATH="${SWIFTBAR_PLUGIN_PATH:-$0}"
DATA_DIR="${SWIFTBAR_PLUGIN_DATA_PATH:-/tmp/swiftbar-gpu-monitor}"
SELECT_FILE="$DATA_DIR/selected_server"

if [ "$1" = "--set-server" ] && [ -n "$2" ]; then
  mkdir -p "$DATA_DIR"
  printf "%s" "$2" > "$SELECT_FILE"
  exit 0
fi

selected_name="$DEFAULT_SERVER_NAME"
if [ -f "$SELECT_FILE" ]; then
  selected_name="$(cat "$SELECT_FILE" 2>/dev/null)"
fi

selected_host=""
selected_key=""
fallback_name=""
fallback_host=""
fallback_key=""

for entry in "${SERVERS[@]}"; do
  IFS='|' read -r name host key <<< "$entry"
  if [ -z "$fallback_host" ]; then
    fallback_name="$name"
    fallback_host="$host"
    fallback_key="$key"
  fi
  if [ "$name" = "$selected_name" ]; then
    selected_host="$host"
    selected_key="$key"
    break
  fi
done

if [ -z "$selected_host" ]; then
  selected_name="$fallback_name"
  selected_host="$fallback_host"
  selected_key="$fallback_key"
fi

if [ -z "$selected_host" ]; then
  echo "GPU: No server configured | color=red"
  echo "---"
  echo "Please configure SERVERS in the script."
  exit 0
fi

SSH_ARGS=(/usr/bin/ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5)
if [ -n "$selected_key" ]; then
  SSH_ARGS+=(-i "$selected_key")
fi

# 获取数据
RAW_DATA=$("${SSH_ARGS[@]}" "$selected_host" "nvidia-smi --query-gpu=index,name,utilization.gpu,memory.free,memory.total --format=csv,noheader,nounits" 2>&1)

## Slurm集群
# 方案A：获取集群中所有 GPU 类型节点的空闲/总计情况
# RAW_DATA=$("${SSH_ARGS[@]}" "$selected_host" "sinfo -O 'NodeList:20,Gres:20,GresUsed:20,StateLong' --noheader | grep -i gpu")
# 方案B：通过 srun 在指定节点上远程执行 nvidia-smi
# RAW_DATA=$("${SSH_ARGS[@]}" "$selected_host" "srun -w node01 nvidia-smi --query-gpu=index,name,utilization.gpu,memory.free,memory.total --format=csv,noheader,nounits")


# 错误处理
if [ $? -ne 0 ] || [ -z "$RAW_DATA" ]; then
  echo "GPU[$selected_name]: Offline | color=red"
  echo "---"
  echo "Error: ${RAW_DATA:0:50}..."
  exit 0
fi

# 使用 -v 传递变量，防止报错
echo "$RAW_DATA" | awk -F', ' -v label="$selected_name" '
BEGIN {
  free_count = 0
  total_count = 0
  menu_content = ""
}
{
  idx = $1
  name = $2
  util = $3
  mem_free = $4
  mem_total = $5
  total_count++

  # === 名字处理 ===
  gsub(/NVIDIA /, "", name)
  split(name, a, "-"); if(length(a[1])>0) name=a[1]

  # === 状态判定 ===
  if (util < 5 && mem_free > 4000) {
    icon = "🟢"
    free_count++
    # 之前这里留空导致变灰，现在我们不指定颜色，但通过后面的 refresh=true 激活它
    line_color = "" 
  } else {
    icon = "🔴"
    line_color = " | color=#FF453A"
  }

  # === 格式化 ===
  line = sprintf("%s [%s] %s: %dMB/%dMB Free (Util:%d%%)", icon, idx, name, mem_free, mem_total, util)
  
  # 关键修改：添加了 refresh=true
  # 这会让每一行都变成可点击的“活跃”状态，macOS 就会用正常的黑色/白色渲染它，而不再是灰色！
  menu_content = menu_content sprintf("%s | font=Menlo size=12 refresh=true%s\n", line, line_color)
}
END {
  # === 顶部栏 ===
  if (free_count == 0) { top_color=" | color=red" } else { top_color="" }
  printf "GPU[%s]: %d/%d Free%s\n", label, free_count, total_count, top_color
  print "---"
  # === 下拉内容 ===
  printf "%s", menu_content
}
'

echo "---"
echo "Server: $selected_name ($selected_host)"
for entry in "${SERVERS[@]}"; do
  IFS='|' read -r name host key <<< "$entry"
  line_label="$name ($host)"
  line="$line_label | bash=$SCRIPT_PATH param1=--set-server param2=$name terminal=false refresh=true"
  if [ "$name" = "$selected_name" ]; then
    line="$line checked=true"
  fi
  echo "$line"
done
echo "---"
echo "Refresh All | refresh=true"
echo "Open Terminal | shell=ssh param1=$selected_host terminal=true"
