# OAuth2 Provider Templates

Community-maintained OAuth2 provider templates for [TRMNL](https://trmnl.com) private plugins.

These templates auto-fill OAuth configuration when users select a provider. Users still need to create their own OAuth app and enter their `client_id` / `client_secret`.

## Adding a Provider

1. Fork this repo
2. Edit `providers.yml` — copy a similar existing entry and fill in the fields
3. Open a PR

### Required Fields

| Field | Description |
|-------|-------------|
| `keyname` | Unique identifier (lowercase, hyphenated) |
| `display_name` | Human-readable name shown in dropdown |
| `category` | Category for grouping(see providors.yml) |
| `authorize_url` | OAuth2 authorization endpoint |
| `token_url` | OAuth2 token endpoint |
| `pkce_enabled` | `'yes'` or `'no'` |

### Optional Fields

All optional fields are documented in the YAML header comments at the top of `providers.yml`.

## Community Help Wanted

This list is community-maintained and some providers may have outdated URLs or deprecated OAuth2 endpoints. We welcome contributions to keep things current:

- **Report a broken provider** — [open an issue](../../issues/new?template=broken-provider.md) if a provider no longer works
- **Fix a provider** — submit a PR with corrected URLs, scopes, or fields
- **Remove a dead provider** — if a service has shut down, open a PR to remove it

## Schema Reference

The full schema is documented in the YAML header comments at the top of `providers.yml`.

## Attribution

Part of the factual api data was ported from the aggregated lists located in:
- Nango https://github.com/NangoHQ/nango
- NextAuth https://github.com/nextauthjs/next-auth
- Grant https://github.com/simov/grant
- Handshake https://github.com/portalform/handshake


## License

MIT — see [LICENSE](LICENSE).
