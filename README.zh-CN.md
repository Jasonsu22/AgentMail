# Agent Mail

[English](README.md) | [简体中文](README.zh-CN.md)

一个运行于 [OctoSense](https://github.com/OctoSense-org/OctoSense) 的智能邮件应用，
具备 AI 能力。基于 `mail` 宿主服务构建——应用永远看不到你的密码。

## 功能

- **读取与管理邮件** — 收件箱、文件夹、撰写、回复、发送
- **AI 总结、待办与安全提示** — 主动点击 AI 总结后，提取只属于当前用户且有原文依据的待办，并保守识别钓鱼邮件、诈骗请求和可疑链接；普通私人邮件与广告不会仅凭类型被标记为风险
- **对话确认加入待办** — 总结展示待办建议后询问是否加入 AgentMail 待办；回复“可以”或“全部加入”可批量添加，也可指定部分事项。拒绝时保留建议，已加入的事项不会重复添加；日历日程单独确认
- **发送前检查** — 点击「检查回复／检查邮件」，对照原邮件和草稿核验漏答、标题、数字、日期、矛盾及明显笔误；可查看原文、选择单项修正或自行填写缺失答案，不做措辞润色。附件状态不可读取时提示人工核对；草稿变化后需重新检查
- **宿主保管凭证** — 在设备自带的面板上登录；密码保存在平台密钥链中
- **离线优先** — 助手是可选功能；即使不可用，所有界面仍正常工作

## 目录结构

```text
bundle/
  manifest.json     id: agent-mail, 权限: storage + mail + octos.*
  listing.json      商店文案（发布者信息为占位符——提交前请替换）
  main.splash       主程序
  assets/icon.svg   图标
```

## 尝试运行

```sh
# 在 card-host 中（仅 UI — mail 服务返回 "no service answers"）
cd OctoScript-App-Design-Flow
python tools/octo run bundle --port 8141

# 完整体验在 OctoSense 桌面端中
#（mail、账号和助手均可使用）
```

## 许可证

MIT
