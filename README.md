# Agent Mail

[English](README.md) | [简体中文](README.zh-CN.md)

A smart email app for [OctoSense](https://github.com/OctoSense-org/OctoSense) with
AI-powered summarization. Built on the `mail` host service — the app never sees
your password.

## Features

- **Read & manage mail** — inbox, folders, compose, reply, send
- **AI capabilities** — tap Summarize on any message and let the assistant work for you
- **Host-owned credentials** — sign in on the device's own sheet; passwords stay in the platform keychain
- **Offline-first UI** — the assistant is optional; every screen works without it

## Structure

```text
bundle/
  manifest.json     id agent-mail, capabilities storage + mail + octos.*
  listing.json      store text (publisher placeholders — replace before submitting)
  main.splash       the app
  assets/icon.svg
```

## Try it

```sh
# In card-host (UI only — mail service returns "no service answers")
cd OctoScript-App-Design-Flow
python tools/octo run bundle --port 8141

# Full experience in the OctoSense desktop shell
# (mail, accounts, and the assistant all work)
```

## License

MIT