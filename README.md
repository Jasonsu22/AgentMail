# Agent Mail

[English](README.md) | [简体中文](README.zh-CN.md)

A smart email app for [OctoSense](https://github.com/OctoSense-org/OctoSense) with
AI-powered summarization. Built on the `mail` host service — the app never sees
your password.

## Current runnable features (14 groups)

1. **Multiple accounts and protected credentials** — add or remove accounts through the system sign-in sheet; the host and platform keychain keep passwords, never AgentMail.
2. **Mailbox sync and folder browsing** — expand accounts, browse Inbox / All Mail / Sent / Drafts and other folders, page through synchronized mail, refresh, and see unread state.
3. **Message reading** — view sender, subject, body, attachment names and original text; return to a source message from summaries, to-dos or subscriptions.
4. **Compose, reply and drafts** — write new mail or replies, save to the account's Drafts, recover local drafts after restart, and keep the most recently saved draft first.
5. **Reviewed sending** — hand messages to the host's foreground review flow; AgentMail never bypasses that review to send directly.
6. **Conversational mail assistant** — use natural language to browse, find, time-filter, open, draft or reply to mail; the UI uses the user's language and does not expose internal tool names.
7. **AI summaries, translation and original text** — request a summary, translate subject and body into the configured language, and restore the original.
8. **Phishing and fraud warnings** — when summarizing, conservatively inspect impersonation, suspicious links, credential/code requests, unusual payments and account changes; show evidence-backed ⚠️ warnings without treating personal mail, marketing mail or urgency alone as malicious.
9. **To-do extraction and management** — extract clearly recipient-owned unfinished actions and explicit deadlines with source quotes; after confirmation, track, complete, ignore, re-add, edit or delete AgentMail to-dos.
10. **Calendar detection and macOS Calendar writing** — find one schedule in a message, show title/time/place, and only after a second confirmation request device permission, choose a calendar, write and read back the event.
11. **Mail classification** — only on request, classify a recent batch into existing folders; it never invents folders or sorts mail automatically.
12. **Pre-send correctness checks** — compare source mail, recipient, subject and draft for unanswered questions, factual/number/date mismatches, contradictions and obvious typos. View evidence, fix individual items or fill an answer without style rewriting. Unknown attachment state is explicitly left for manual verification.
13. **Sender subscriptions and focused briefings** — confirm subscribe/unsubscribe per sender, group synchronized mail by sender in the sidebar, repeatedly generate a fresh current briefing inside a sender, ask scoped questions and open cited source mail.
14. **Sessions, personalization and settings** — create, restore and delete chat history with confirmation; configure UI language, translation language, AI provider/model connection, and localized errors.

## Limits and safety

- AI summaries, translation, checks and briefings require a configured, available AI provider; non-AI mail, draft and settings screens remain usable without it.
- Subscriptions group only mail already synchronized to the device, deduplicate copies across folders, never move mail or change a sender's mailing-list enrollment, and refresh every 90 seconds only while the app is open.
- Each subscription briefing or scoped question freshly reads at most the latest 12 indexed emails and the first 8,000 bytes of each. Unsynchronized server history is unavailable; truncation and read failures are disclosed.
- Actions with external impact—sending, Calendar writes, to-do changes, subscription changes and deleting a chat—require a visible user confirmation. Email content is never treated as authorization.

## Demo and verification

The repository includes repeatable isolated fixtures: 27 to-do/draft checks, 22 pre-send checks, 26 subscription checks, and one subscription cold-start check. They use temporary state plus simulated mail/model services, so they safely demonstrate confirmations, errors and boundaries without accessing a real mailbox, sending email or writing a real calendar. A live demo should use only read-only mail actions and wait for the real AI response; show the confirmation UI for sending and Calendar writing unless an operator explicitly approves execution.

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
