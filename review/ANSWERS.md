# App Hub scan answers — AgentMail 0.30.117

## 1. Listing claims

Pass. `bundle/listing.json` describes reading and translating mail, generating
summaries, flagging suspected phishing, extracting to-dos, preparing calendar
events after confirmation, and checking a draft before send. These flows are
implemented in `bundle/main.splash`: `tool_summarize`, `tool_translate`,
`tool_find_event`, `tool_add_event`, `start_mail_check`, and the composer
review path. The listing also discloses that screenshots use demonstration
data.

## 2. Platform and category

Pass. The listing names only `macos`, the platform exercised for this release.
`productivity` fits a mail-reading, drafting, summarization and task workflow.

## 3. Capabilities

Pass. `bundle/manifest.json` declares only the services visible in the app:

- `mail` reads host-authorized accounts and messages and creates drafts; the
  host's reviewed send flow requires a physical approval.
- `model` summarizes, translates, checks drafts, and answers questions using
  the person's configured model provider.
- `device_calendar` requests permission, lets the person select a calendar,
  and asks for host review before event creation.
- `storage` keeps app-owned preferences, local drafts, summaries, translations,
  to-dos, subscriptions, and chat history on-device.

The exact required device-calendar methods are listed in the manifest's
`host_api.required`; no network hosts are declared.

## 4. Deceptive interface

Pass. `bundle/main.splash` uses app-owned sheets for confirmations and labels
them as AgentMail UI. It does not imitate an operating-system login, payment
sheet, or another brand's sign-in surface. Mail sending and calendar writes use
the separate native host review flow.

## 5. Assistant-directed text

Human review requested. The source contains model prompts used to constrain
the app's own calls, notably the controller and summarization prompts in
`bundle/main.splash`. Their purpose is to treat mail as untrusted input, avoid
following instructions found inside messages, and prevent automatic writes.
They are not displayed as instructions to a user or a separate app agent.

## 6. Abusive or targeted wording

Pass. User-facing copy in `bundle/main.splash`, `bundle/listing.json`, and
`PRIVACY.md` is product guidance. The fictional screenshot uses the neutral
name “Jason” only as email salutation and contains no personal data from a
real mailbox.

## 7. Recommended route

Human review. The unsigned editable source passes the development gate. A
human should confirm the model-prompt boundaries, macOS host-service behavior,
and the GitHub-attested release pack once the tag workflow completes.
