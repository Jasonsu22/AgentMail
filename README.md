# Agent Mail

[English](README.md) | [简体中文](README.zh-CN.md)

A smart email app for [OctoSense](https://github.com/OctoSense-org/OctoSense) with
AI-powered summarization. Built on the `mail` host service — the app never sees
your password.

## Features

- **Read & manage mail** — inbox, folders, compose, reply, send
- **AI summaries, to-dos, and safety hints** — on request, extract user-owned action items backed by an exact quote and conservatively flag phishing, fraud requests, and suspicious links without treating ordinary personal or marketing mail as malicious by default
- **Confirm to-dos in chat** — after showing suggestions, ask whether to add them to AgentMail To-dos. Agree to add all or choose specific items; declining keeps the suggestions, and tracked items are not added twice. Calendar events are confirmed separately
- **Sender subscriptions and briefings** — confirm tracking changes, browse compact sender summaries and grouped emails from the sidebar, and ask questions within the selected subscription scope. Topic-filtered editions merge duplicate coverage, compare against the preceding matching edition, cite source quotes and body links, and offer a read-later list with hierarchical navigation
- **Host-owned credentials** — sign in on the device's own sheet; passwords stay in the platform keychain
- **Offline-first UI** — the assistant is optional; every screen works without it

Subscriptions group received mail already synchronized by the host across folders,
without moving messages or changing mailing-list enrollment. Refresh is attempted
every 90 seconds while the app is open; there is no closed-app background worker.
Each edition reads up to 12 unprocessed messages and 8,000 bytes per message;
truncation and failures are disclosed. Questions read the latest 12 messages.
Links are taken only from supplied body text, without browsing. Unsynchronized
server history and HTML-only destinations not present in plain text may be unavailable.
Empty topics mean no topic subscription: briefing generation does not call AI or
default to all topics. Explicit sender subscriptions remain. Sync failures show
a separate warning while cached mail stays usable; TLS verification is never disabled.

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
