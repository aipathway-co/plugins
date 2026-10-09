# AI Pathway plugins

Claude plugins that run your business. This repo is a **plugin marketplace** — add
it in Claude Code or Cowork and install the plugin for your industry.

```
/plugin marketplace add aipathway-co/plugins
/plugin install ai-staff
```

## Plugins

This marketplace carries one plugin per industry. Install the one for your
company's industry.

| Plugin | Industry | What it is |
|--------|----------|------------|
| **[`ai-staff`](./ai-staff)** | Trades | Named back-office agents (starting with **Vinnie the Vendor Bill Coder**) that run in your Cowork. |

## Layout

- **One plugin per industry.** Each plugin is a sibling directory (`ai-staff/`
  for trades; future industries will be named `ai-staff-<industry>`) and is
  listed in `.claude-plugin/marketplace.json`.
- **Shared stubs.** The platform-mechanic stubs every industry plugin needs
  (`review-work-items`, `configure-scheduled-task`, `agent-config`) live once in
  `shared-stubs/`. `scripts/generate-shared-stubs.sh` copies them into every
  `ai-staff*/` plugin directory; never edit the copies by hand.

See [`PUBLISHING.md`](./PUBLISHING.md) for how to change a shared stub, add an
industry plugin, and release.

## Dependencies

The plugins here are thin — they rely on two AI Pathway connectors, set up through
your AI Pathway onboarding:
- **Mission Control** — serves each agent's versioned method and holds config + audit.
- **QuickBooks** — where accounting reads/writes happen.

The agents fetch their actual method from Mission Control at run time, so this
repo ships only discovery stubs — no proprietary logic, no company data. That's
why it can be public. See [`PUBLISHING.md`](./PUBLISHING.md) for how releases and
marketplace listing work.

---
© AI Pathway.
