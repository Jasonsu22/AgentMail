# Agent Mail

[English](README.md) | [简体中文](README.zh-CN.md)

一個運行於 [OctoSense](https://github.com/OctoSense-org/OctoSense) 的智能郵件應用，
內建 AI 摘要功能。基於 `mail` 宿主服務構建——應用永遠看不到你的密碼。

## 功能

- **讀取與管理郵件** — 收件箱、文件夾、撰寫、回覆、發送
- **AI 摘要** — 在任何郵件上點擊 Summarize，一鍵獲取一句話摘要
- **宿主保管憑證** — 在設備自帶的面板上登入；密碼保存在平台密鑰鏈中
- **離線優先** — 助手是可選功能；即使不可用，所有界面仍正常工作

## 目錄結構

```text
bundle/
  manifest.json     id: agent-mail, 權限: storage + mail + octos.*
  listing.json      商店文案（發布者信息為佔位符——提交前請替換）
  main.splash       主程式
  assets/icon.svg   圖標
```

## 嘗試運行

```sh
# 在 card-host 中（僅 UI — mail 服務返回 "no service answers"）
cd OctoScript-App-Design-Flow
python tools/octo run bundle --port 8141

# 完整體驗在 OctoSense 桌面端中
#（mail、帳號和助手均可使用）
```

## 狀態

- [x] 完整郵件 UI（收件箱、閱讀器、撰寫器、文件夾、帳號）
- [x] AI 摘要按鈕（調用 `octos.turn.start`）
- [ ] 截圖已截取
- [ ] 發布者信息已填寫（`listing.json`）
- [ ] 已簽名並提交至 App Hub

## 許可證

MIT