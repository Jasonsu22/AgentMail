# AgentMail 提交 App Hub

首发**不签名**即可。文档允许 unsigned 第一次提交；商店最终信的是 Hub 维护者签的目录，不是你的测试钥。

本机已把 `bundle/manifest.json` 去掉 `signature`，并 stamp。

## 刚才的核验（2026-10-04）

```text
hub stamp bundle
→ b0c5d61c8d55e8bd7fd676ddd75d46a98e6045b091bbbaae630271cedf4f9dad

hub check bundle --allow-unsigned
agent-mail 0.30.66 — PASSED
  [warning] publisher-signature: unsigned: accountability rests on the hub alone
  grants: capabilities {"mail", "model", "storage"}, hosts {}, storage 16777216 bytes, agent none

hub check bundle --allow-unsigned --catalog OctoSense-App-Hub/catalog.json
→ 同样 PASSED（官方目录里还没有 agent-mail，版本不撞车）

hub scan bundle --packet build/review.json
→ 7 个问题，无 reviewer；packet 在 build/，不要提交进 git
```

和别人那次 `agentic-mail 0.1.0 — PASSED` + unsigned 警告是同一档。不要再带 `--publisher-key`，也不要重新签 `agent-mail-test`。

签完再改任何文件都会坏 digest；保持 unsigned，提交前若再改 `bundle/`，只需再跑 `hub stamp` + `hub check --allow-unsigned`。

## 提交前还要做（人）

闸门不审 listing 文案和隐私链接，审核人会审。

- [ ] `listing.json` 去掉占位：现在 `support` / `privacy_policy_url` 仍是 `example.com`。换成真实 https 页。发布者名称「AAA养鸡场」若就是对外名称可保留。
- [ ] 确认 `screenshots/01-main.png` 是真人操作截的，不是空帧或假图；人看过。
- [ ] `platforms` 只写实际跑过的（当前 `macos`, `windows`）。没在 Linux/手机上跑就不要加。
- [ ] 版本号：可用现在的 `0.30.66`，或改成 `0.1.0` 再 stamp/check。官方目录尚未占用 `agent-mail`。**改完必须再 stamp + check。**
- [ ] 把最终 `bundle/` 推进公开仓库并打 tag（例如 `v0.30.66`）。
- [ ] 用本人 GitHub 账号开 issue，**不要**给 OctoSense-App-Hub 提改 `catalog.json` / `artifacts/` / `index/` 的 PR。

建议仓库：`https://github.com/Jasonsu22/AgentMail`（以你实际推送的为准）。应用包路径：`bundle/`。

## Issue

标题：

```text
Submit agent-mail 0.30.66
```

正文模板（填 SHA 和 tag 后贴上）：

```text
## App
- id: agent-mail
- version: 0.30.66
- name: AgentMail
- repository: https://github.com/Jasonsu22/AgentMail
- tag:
- commit (full SHA):
- bundle path: bundle/

## Signing
unsigned first submission

## hub check
```

agent-mail 0.30.66 — PASSED
  [warning] publisher-signature: unsigned: accountability rests on the hub alone
  grants: capabilities {"mail", "model", "storage"}, hosts {}, storage 16777216 bytes, agent none

```

（提交前请在打 tag 的那次 commit 上再跑一遍 check，把原样输出贴这里。）

## Scan answers
见下方七问。

## Tested
- Windows desktop OctoSense：加账号、邮件列表、文件夹、设置改名、Agent 侧栏。
- 未测：iOS、Android 侧载（文档写明手机不能侧载未上架包）、Linux、macOS（若没跑过请从 platforms 去掉 macos）。
```



## hub scan 七问（草稿，提交前你改）

1. **名称/副标题/描述是否属实？**
  是。`AgentMail` / 「带 AI 的邮件应用」：侧栏多账号、邮件列表与读写、宿主登录（应用不收密码）、设置里一次性 `model.complete`。源码 `bundle/main.splash` 调用 `mail.*` 与 `model.complete`。
2. **platforms 和 category 是否合适？**
  `category: productivity` 合适。`platforms` 只应保留实际跑过的系统。
3. **权限是否和界面一致？**
  `mail`：加账号、收发、文件夹。`storage`：自定义显示名 `names.txt`。`model`：设置里测连接、Agent 提问、摘要。`network.hosts` 为空，没有 `net`。没有多余的 `octos.*` / `llm`。
4. **界面是否欺骗（假系统提示、支付、登录、仿品牌）？**
  否。登录走 OctoSense 宿主面板；设置写明不收 API key。
5. **源码里是否有写给助手而不是给人看的指令？**
  `model.complete` 的 `task` 是一次性补全说明（邮件问答/摘要），不是让别的应用 Agent 或系统 Agent 做事。请审核人过目。
6. **是否有辱骂或针对私人的文案？**
  否。
7. **Route：** 建议 `human-review`（首发必等人审），理由：unsigned 首发；listing 隐私/支持 URL 需人确认。



## 维护者随后会做（你不用做）

Checkout 你的 tag → 再跑 `hub check` / `hub scan` → `hub publish` 写入官方 `catalog.json` 和 `artifacts/`。Issue 关掉并写上 catalog sequence 之后，别人才能在官方商店 Get。

## 不要做

- 不要把 `build/`、`*.key`、`.local-state/` 推进 git（已在 `.gitignore`）。
- 不要给 App Hub 提 catalog PR。
- 不要用本机 `publish-desktop.ps1` 代替官方提交。
- 提交前改了 `bundle/` 必须再 `hub stamp` 和 `hub check --allow-unsigned`。

