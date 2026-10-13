# Agent Mail

[English](README.md) | [简体中文](README.zh-CN.md)

A smart email app for [OctoSense](https://github.com/OctoSense-org/OctoSense) with
AI-powered summarization. Built on the `mail` host service — the app never sees
your password.

## Features

- **Read & manage mail** — inbox, folders, compose, reply, send
- **AI summaries, to-dos, and safety hints** — on request, extract user-owned action items backed by an exact quote and conservatively flag phishing, fraud requests, and suspicious links without treating ordinary personal or marketing mail as malicious by default
- **Confirm to-dos in chat** — after showing suggestions, ask whether to add them to AgentMail To-dos. Agree to add all or choose specific items; declining keeps the suggestions, and tracked items are not added twice. Calendar events are confirmed separately
- **Pre-send correctness checks** — compare the original email, subject and draft for unanswered questions, factual discrepancies, date mismatches, contradictions and clear typos. View evidence and apply individual corrections or supply missing answers, without style rewrites. Unknown outgoing attachment status requires manual verification; changed drafts must be checked again
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
