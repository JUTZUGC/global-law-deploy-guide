# Global Law 一键部署指南

> 第三方部署指南 · 非 Global Law 官方仓库。官方项目：[lexifina/global-law](https://github.com/lexifina/global-law)
> 内容来自官方文档（2026-10-31）。项目迭代快，请以[官方文档](https://github.com/lexifina/global-law#readme)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 法律也能量化到某一天：单条命令问「2022 年 5 月 1 日这条法是什么样」，答案会标明记录从哪开始、到哪结束。

⚠️ 需要 Python 3.10+ 与 git，克隆必须带 `--recurse-submodules`，否则各国法条的子模块是空的。语料覆盖差异很大：有的国家是全本法典，有的只有几部法或抽样；`manifest.json` 里写明每个语料的覆盖范围与历史可信度。它不联网、只读仓库，也不构成法律意见。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/global-law-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会确认 Python 3.10+ 与 git，递归克隆（含子模块），再把 MCP server 注册到当前客户端，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## Global Law 是什么？

Global Law 是开源的每个国家一份法律仓库，每一次生效都是一次提交；在这里能问某条法在某一天到底写了什么（协议：CC0-1.0，<img src="https://img.shields.io/github/stars/lexifina/global-law?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

把多个司法辖区的法律按生效时间交织成一条 git 历史：每个国家是独立仓库与子模块，MCP server 负责按日期与条文回答当时的文本，并说明记录边界。

- 时间可查：任意日期上某条法的原文
- 边界清楚：每个答案标明记录起止
- 结构清晰：manifest 列出覆盖范围与历史来源
- 完全离线：只读本地仓库，不联网
- 自带 MCP：Claude Code、Cursor、Claude Desktop 都能接
- CC0：可自由使用与再分发

（来源：[官方仓库](https://github.com/lexifina/global-law)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 1 | . |
| 按 | 日 |
| 答 | 案 |
| 完 | 全 |
| 自 | 带 |
| C | C |

| 需要注意 | 说明 |
|---|---|
| 语 | 料 |
| 必 | 须 |
| 只 | 做 |
| 需 | 要 |
| 非 | 英 |

> 以上基于官方文档与社区反馈整理（2026-10-31），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone --recurse-submodules https://github.com/lexifina/global-law.git
cd global-law
python -c "import sys; sys.exit(0 if sys.version_info >= (3, 10) else '需要 Python 3.10 或更高版本')"
claude mcp add global-law -- python tools/mcp_server.py
echo "已注册：在会话里问某条法在某个日期的内容"
```

部署步骤来源：[https://github.com/lexifina/global-law#using-it-from-an-ai-model-mcp](https://github.com/lexifina/global-law#using-it-from-an-ai-model-mcp)

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认递归克隆、Python 3.10+ 与 MCP 注册命令 | 已核对 2026-10-31 |
| README 确认语料覆盖差异与 manifest 的作用 | 已核对 2026-10-31 |
| LICENSE.md 标明 CC0（各国法条按其仓库自身条款） | 已核对 2026-10-31 |
| 未实测克隆与 MCP 查询 | 说明 2026-10-31 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-10-31 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-31 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

仓库自带 MCP server（`tools/mcp_server.py`），用 Python 3.10+ 与 git 即可运行，支持 stdio；本仓库的 MCP 只提供部署步骤与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-31）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\global-law-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 克隆与注册

```bash
git clone --recurse-submodules https://github.com/lexifina/global-law
cd global-law
python -c "import sys; print(sys.version)"
claude mcp add global-law -- python tools/mcp_server.py
```

其它客户端（Claude Desktop、Cursor 等）用这段配置，把路径换成自己的绝对路径：

```json
{
  "mcpServers": {
    "global-law": {
      "command": "python",
      "args": ["/你的路径/global-law/tools/mcp_server.py"]
    }
  }
}
```

仓库里也带 `.mcp.json`，在 Claude Code 里直接批准项目配置即可。

## 可以这样问

- 「2022 年 5 月 1 日，11 U.S.C. §1182(1) 写的是什么，最后是哪部法改的？」
- 「德国基本法第 1 条在 2000 年是什么文本？」
- 「这个国家的语料覆盖到哪一年？」

## 目录结构

| 文件或目录 | 作用 |
|---|---|
| `manifest.json` | 每个语料的路径、来源仓库、覆盖范围、生效日期的来源 |
| `jurisdiction.json` | 193 个联合国成员国、其它 ISO 地区与欧盟 |
| `<国家>/` | 该国的 `jurisdiction.json`、`SOURCES.md` 与法律子模块 |

## 注意

- 克隆必须带子模块参数，否则只有骨架没有法条
- 语料覆盖不均，先看 `manifest.json` 再下结论
- 部分语料只有「当前版本」，没有历史，答案里会写明
- 只读本地数据，不联网；要更新需自己 `git pull` 并更新子模块
- 这不是法律意见，正式使用前请核对官方原文

## 常见坑

- 查不到任何法条：克隆时漏了 `--recurse-submodules`，重新拉一次
- MCP 连不上：配置里必须写 python 脚本的绝对路径
- 答案说「没有记录」：该国家的语料可能只覆盖近期，先看 manifest
- Python 版本过低：需要 3.10 及以上
- 更新后仍然是旧法：`git pull` 之后还要 `git submodule update --remote`
- 把答案当法律意见：不要，正式场景请核对官方文本

## 免责声明

本仓库为第三方指南，与 Global Law 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-31），项目迭代快，请以[官方文档](https://github.com/lexifina/global-law#readme)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
