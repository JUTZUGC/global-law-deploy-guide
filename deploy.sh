#!/usr/bin/env bash
set -euo pipefail
# Global Law 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/lexifina/global-law#readme
# 更新日期：2026-10-31
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1 || { echo "需要先安装 Python 3"; exit 1; }

mkdir -p .download
cd .download

git clone --recurse-submodules https://github.com/lexifina/global-law.git
cd global-law
python -c "import sys; sys.exit(0 if sys.version_info >= (3, 10) else '需要 Python 3.10 或更高版本')"
claude mcp add global-law -- python tools/mcp_server.py
echo "已注册：在会话里问某条法在某个日期的内容"

echo ""

echo "部署完成"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/lexifina/global-law#readme"
