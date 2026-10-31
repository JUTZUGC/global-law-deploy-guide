# Global Law 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/lexifina/global-law#readme
# 更新日期：2026-10-31
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }
if (-not (Get-Command python -ErrorAction SilentlyContinue)) { throw '需要先安装 Python 3' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

git clone --recurse-submodules https://github.com/lexifina/global-law.git
Set-Location global-law
python -c "import sys; sys.exit(0 if sys.version_info >= (3, 10) else '需要 Python 3.10 或更高版本')"
claude mcp add global-law -- python tools/mcp_server.py
Write-Host "已注册：在会话里问某条法在某个日期的内容"

Write-Host ''

Write-Host '部署完成'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/lexifina/global-law#readme'
