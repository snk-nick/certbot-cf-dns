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

Testing:

1. Create a .env file with the required environment variables or set them via CLI/the compose file directly.
2. Build images: `make`
3. Test the latest python-cloudflare package: `make run-new`
4. Test the older working python-cloudflare package: `make run-old`
5. Shutdown and delete all containers, remove volumes, and images: `make remove`