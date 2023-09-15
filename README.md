# certbot-cf-dns
The current official builds don't seem to work due to an issue with the python-cloudflare package
(Very) quick testing showed this issue persists for all versions after v2.8.15, with any attempt
to use a token instead of a global API key failing after that point. This container should NOT be
used in production without additional testing to ensure it functions as expected, but feel free.

Required environment variables:
* CLOUDFLARE_TOKEN: Cloudflare token with appropriate permissions (NOT an API key).
* CLOUDFLARE_EMAIL: Email to register domain with.
* CLOUDFLARE_DOMAIN_LIST: List of domains to register in certbots expected format, eg:
                        "domain.com"                       - Single domain
                        "*.domain.com -d test.domain.com"  - Multiple with wildcard