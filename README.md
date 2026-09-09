# AI Pathway plugins

Claude plugins that run your business. This repo is a **plugin marketplace** — add
it in Claude Code or Cowork and install the plugins below.

```
/plugin marketplace add aipathway-co/plugins
/plugin install ai-staff
```

## Plugins

| Plugin | What it is |
|--------|------------|
| **[`ai-staff`](./ai-staff)** | Named back-office agents (starting with **Vinnie the Vendor Bill Coder**) that run in your Cowork. |

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
