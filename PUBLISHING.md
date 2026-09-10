# Publishing & releasing

This repo is a **Claude plugin marketplace** (`aipathway-co/plugins`). It's public
on purpose — it contains only IP-free discovery stubs; the methods and server stay
in `mission-control-mcp` (private) and Mission Control's DB. See the root
`README.md` for the architecture.

## Distribution model (no Anthropic gatekeeping required)

Because it's a public marketplace repo, anyone can add and install it directly:
```
/plugin marketplace add aipathway-co/plugins
/plugin install ai-staff
```
This is the primary, fully-in-your-control distribution path — use it for
onboarding customers today. Nothing below is required for this to work.

## Validate before every merge/release

CI runs it automatically (`.github/workflows/validate.yml`), and you can run it
locally — it's the same check the community-marketplace review runs:
```
claude plugin validate .            # the marketplace manifest
claude plugin validate ./ai-staff   # the plugin
```

## Cutting a release (automated)

1. Bump the version in the changed plugin's manifest
   (`ai-staff/.claude-plugin/plugin.json` → `"version"`), following semver.
   **CI fails the PR if you changed `ai-staff/` without bumping it** — an
   unbumped change is invisible to installs, because `/plugin update` compares
   versions and sees no difference.
2. Merge to `main`.
3. Nothing. `.github/workflows/release.yml` validates the manifests, then
   creates the `ai-staff-vX.Y.Z` tag and the GitHub release automatically.
   It is idempotent: if the version already has a tag (i.e. the push did not
   change the plugin), it exits without releasing.

Installs pick up the new version on the next marketplace refresh
(`/plugin marketplace update aipathway` then `/plugin update ai-staff`).

> Note: because each agent's *method* is served from Mission Control (not shipped
> here), you rarely need a plugin release — only when a stub, the manifest, or a
> new agent is added. Improving an agent's logic is a Mission Control skill
> publish, not a plugin release.

## Optional: list on the Anthropic community marketplace

To be discoverable in Claude's built-in **`claude-plugins-community`** marketplace
(so users can find it without adding our repo by hand):

1. Ensure `claude plugin validate` passes (CI green) — the review pipeline runs it.
2. Keep the repo public; submissions pin to a specific commit SHA.
3. Submit the marketplace/plugin:
   - Individual authors: <https://platform.claude.com/plugins/submit>
   - Team/Enterprise orgs: the claude.ai admin submissions form
     (`https://claude.ai/admin-settings/directory/submissions/plugins/new`)
4. Anthropic runs automated validation + safety screening before listing.

The curated **`claude-plugins-official`** marketplace has no application process —
Anthropic selects inclusions at its discretion, so there's nothing to submit there.
