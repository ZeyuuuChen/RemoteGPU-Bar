#!/bin/bash

# ================= 配置区域 =================
HOST="user@your_server_ip"
ID_FILE="/Users/zeyu/.ssh/id_rsa"
# ===========================================

SSH_CMD="/usr/bin/ssh -i $ID_FILE -o StrictHostKeyChecking=no -o ConnectTimeout=5"

# 获取数据
RAW_DATA=$($SSH_CMD $HOST "nvidia-smi --query-gpu=index,name,utilization.gpu,memory.free,memory.total --format=csv,noheader,nounits" 2>&1)

## Slurm集群
# 方案A：获取集群中所有 GPU 类型节点的空闲/总计情况
# RAW_DATA=$($SSH_CMD $HOST "sinfo -O 'NodeList:20,Gres:20,GresUsed:20,StateLong' --noheader | grep -i gpu")
# 方案B：通过 srun 在指定节点上远程执行 nvidia-smi
# RAW_DATA=$($SSH_CMD $HOST "srun -w node01 nvidia-smi --query-gpu=index,name,utilization.gpu,memory.free,memory.total --format=csv,noheader,nounits")


# 错误处理
if [ $? -ne 0 ] || [ -z "$RAW_DATA" ]; then
  echo "GPU: Offline | color=red"
  echo "---"
  echo "Error: ${RAW_DATA:0:50}..."
  exit 0
fi

# 使用 -v 传递变量，防止报错
echo "$RAW_DATA" | awk -F', ' -v host="$HOST" '
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
  printf "GPU: %d/%d Free%s\n", free_count, total_count, top_color
  
  print "---"
  
  # === 下拉内容 ===
  printf "%s", menu_content
  
  print "---"
  print "Refresh All | refresh=true"
  print "Open Terminal | shell=ssh param1=" host " terminal=true"
}
'
