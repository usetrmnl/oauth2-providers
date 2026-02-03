# Contributing

Thanks for helping grow the OAuth2 provider list!

## Fixing or Removing a Provider

Some providers may have outdated URLs or no longer support OAuth2. If you spot one:

1. **Report it** — [open a broken provider issue](../../issues/new?template=broken-provider.md)
2. **Fix it** — update the entry in `providers.yml` and open a PR
3. **Remove it** — if the service has shut down, delete the entry and open a PR

## Adding a Provider

1. **One provider per PR** — keeps review simple
2. Copy a similar existing entry in `providers.yml`
3. Fill in all required fields: `keyname`, `display_name`, `category`, `authorize_url`, `token_url`, `pkce_enabled`
4. Open a PR

## Naming Conventions

- `keyname`: lowercase, hyphenated (e.g., `google-calendar`, `hubspot`)
- `display_name`: official product name (e.g., `Google Calendar`, `HubSpot`)

## PR Checklist

- [ ] YAML is valid (CI will check this)
- [ ] All required fields are present
- [ ] `keyname` is unique
- [ ] `category` is from the valid list (see README)
- [ ] URLs use `https://` (or contain `${connectionConfig` for dynamic URLs)
- [ ] Tested the OAuth flow, or linked to the provider's OAuth documentation

## Questions?

Open an issue — we're happy to help.
