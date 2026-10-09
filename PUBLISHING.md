# Publishing & releasing

This repo is a **Claude plugin marketplace** (`aipathway-co/plugins`). It's public
on purpose — it contains only IP-free discovery stubs; the methods and server stay
in `mission-control-mcp` (private) and Mission Control's DB. See the root
`README.md` for the architecture.

## Distribution model (no Anthropic gatekeeping required)

Because it's a public marketplace repo, anyone can add and install it directly:
```
/plugin marketplace add aipathway-co/plugins
/plugin install ai-staff    # the trades plugin
```
This is the primary, fully-in-your-control distribution path — use it for
onboarding customers today. Nothing below is required for this to work.

## Validate before every merge/release

CI runs it automatically (`.github/workflows/validate.yml`), and you can run it
locally — it's the same check the community-marketplace review runs:
```
claude plugin validate .            # the marketplace manifest
claude plugin validate ./ai-staff   # a plugin (repeat for each plugin)
```

## One plugin per industry

The marketplace carries one plugin per industry. Today there is one: `ai-staff`,
the trades plugin (Vinnie the Vendor Bill Coder). It keeps that name because
installed customers reference it, so renaming it would strand them. Future
industry plugins will be named `ai-staff-<industry>` (see the naming rule
below). A customer installs the plugin for their company's industry. Mission
Control decides which agents a company may use; if it refuses an agent (for
example "unknown agent"), the stub stops.

## Shared stubs

Three platform-mechanic stubs are shared by every industry plugin:
`review-work-items`, `configure-scheduled-task` and `agent-config`. The single
source of truth for each is `shared-stubs/<name>/SKILL.md`.
`scripts/generate-shared-stubs.sh` copies them byte-for-byte into
`skills/<name>/SKILL.md` of every `ai-staff*/` directory that has a
`.claude-plugin/plugin.json`. It is idempotent: a second run changes nothing.
It only adds and overwrites, and it never deletes; a symlinked copy is replaced
with a real file. It fails if a `shared-stubs/<name>/` has no `SKILL.md` (or it
is a symlink), or if it finds no shared stubs or no plugin directory.

To change one:

1. Edit `shared-stubs/<name>/SKILL.md`. Never edit the copies under a plugin.
2. Run `scripts/generate-shared-stubs.sh`.
3. Bump the version of every plugin whose directory changed (see below) and
   commit the source and the generated copies together.

To remove a shared stub, delete `shared-stubs/<name>/` and also delete its
copies in every plugin by hand, in the same change. The script will not do it.

CI (`validate.yml`, job "Shared stubs are generated") runs the script and fails
the PR if that leaves any change in the tree.

## Adding an industry plugin

1. Create `ai-staff-<industry>/.claude-plugin/plugin.json` and the
   industry-specific stubs under `ai-staff-<industry>/skills/`. The directory
   name is the plugin name and the release tag prefix
   (`ai-staff-<industry>-vX.Y.Z`), so it must be `ai-staff-` followed by one or
   more groups of lowercase letters and digits separated by single hyphens
   (`ai-staff-lending`, `ai-staff-air-cargo`; release.yml checks
   `^ai-staff(-[a-z0-9]+)*$`). PR CI (`validate.yml`) checks this rule; if a bad
   name ever reached `main`, it would fail the whole release run and block
   every plugin's release until fixed.
   In `plugin.json`, set `"name"` to the directory name and `"version"` to a
   plain `X.Y.Z` (for example `0.1.0`); PR CI rejects anything else.
2. Add it to `.claude-plugin/marketplace.json`:
   `{"name": "ai-staff-<industry>", "source": "./ai-staff-<industry>", "description": "..."}`
3. Run `scripts/generate-shared-stubs.sh` to add the shared stubs, and commit
   the generated copies.
4. Add a row for it to the Plugins table in the root `README.md`.
5. Nothing to do in the workflows. `validate.yml` and `release.yml` read the
   plugin list from the marketplace, so they pick up the new plugin
   automatically.

The PR that creates the plugin needs no version bump. Its manifest does not
exist at the PR's merge base, so there is nothing to compare. The gate only
checks that the `<plugin>-v<version>` tag does not already exist. Every later
change to the plugin does need a bump.

## Cutting a release (automated)

1. Bump the version in the manifest of each plugin whose directory changed
   (for example `ai-staff/.claude-plugin/plugin.json` → `"version"`),
   following semver. A change to a shared stub changes every plugin's copy, so
   it needs a bump in every plugin.
   **CI fails the PR if you changed the directory of any plugin listed in the
   marketplace without bumping its version** — an unbumped change is invisible
   to installs, because `/plugin update` compares versions and sees no
   difference.
2. Merge to `main`.
3. Nothing. `.github/workflows/release.yml` runs once per plugin listed in
   `.claude-plugin/marketplace.json`. For each, it validates the manifests,
   then creates the `<plugin>-vX.Y.Z` tag (for example `ai-staff-vX.Y.Z`) and
   the GitHub release automatically. It is idempotent per plugin: if that
   plugin's version already has a tag (i.e. the push did not change that
   plugin), it exits without releasing that plugin. Duplicate marketplace
   entries collapse to one, and the version must be `X.Y.Z`.

Installs pick up the new version on the next marketplace refresh
(`/plugin marketplace update aipathway` then `/plugin update <plugin>`, for
example `/plugin update ai-staff`).

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
