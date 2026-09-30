# Agent Mail

[English](README.md) | [简体中文](README.zh-CN.md)

一个运行于 [OctoSense](https://github.com/OctoSense-org/OctoSense) 的智能邮件应用，
具备 AI 能力。基于 `mail` 宿主服务构建——应用永远看不到你的密码。

## 功能

- **读取与管理邮件** — 收件箱、文件夹、撰写、回复、发送
- **AI 能力** — 在任何邮件上点击 Summarize，让助手为你工作
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