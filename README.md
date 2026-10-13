# Agent Mail

[English](README.md) | [简体中文](README.zh-CN.md)

A smart email app for [OctoSense](https://github.com/OctoSense-org/OctoSense) with
AI-powered summarization. Built on the `mail` host service — the app never sees
your password.

## Features

- **Read & manage mail** — inbox, folders, compose, reply, send
- **AI summaries, to-dos, and safety hints** — on request, extract user-owned action items backed by an exact quote and conservatively flag phishing, fraud requests, and suspicious links without treating ordinary personal or marketing mail as malicious by default
- **Confirm to-dos in chat** — after showing suggestions, ask whether to add them to AgentMail To-dos. Agree to add all or choose specific items; declining keeps the suggestions, and tracked items are not added twice. Calendar events are confirmed separately
- **Sender subscriptions and briefings** — confirm tracking changes, browse compact sender summaries and grouped emails from the sidebar, and ask scoped questions. Inside a sender's mail list, repeatedly call AI to generate a fresh current briefing displayed above that sender's messages
- **Host-owned credentials** — sign in on the device's own sheet; passwords stay in the platform keychain
- **Offline-first UI** — the assistant is optional; every screen works without it

Subscriptions group received mail already synchronized by the host across folders,
without moving messages or changing mailing-list enrollment. Refresh is attempted
every 90 seconds while the app is open; there is no closed-app background worker.
Each briefing and question freshly reads up to the latest 12 messages in scope and
8,000 bytes per message; truncation and failures are disclosed. Unsynchronized
server history is unavailable. Sync failures show a separate warning while cached
mail stays usable; TLS verification is never disabled.

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
