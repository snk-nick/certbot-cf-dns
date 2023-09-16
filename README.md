# Certbot Testing

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

## Prerequisites

- Docker
- Docker Compose
- GNU Make

## Make Commands

For simpler/consistent testing a Makefile is included:

- `make all`: Build both `certtest:old` and `certtest:new` images.
- `make build-old`: Build the `certtest:old` image.
- `make build-new`: Build the `certtest:new` image.
- `make run-old`: Run the `certtest:old` image.
- `make run-new`: Run the `certtest:new` image.
- `make run-old-detached`: Run the `certtest:old` image in detached mode.
- `make run-new-detached`: Run the `certtest:new` image in detached mode.
- `make remove`: Remove all resources (containers, networks, volumes, and images) related to this project.

### Building Images

Build both `certtest:old` and `certtest:new` images, run:

```bash
make all
```

Build only the `certtest:old` image, run:

```bash
`make build-old`
```

Build only the `certtest:new` image, run:

```bash
make build-new
```

### Running Containers

To run the `certtest:old` image, run:
```bash
make run-old
```

To run the `certtest:new` image, run:

```bash
make run-new
```

To run the `certtest:old` image in detached mode, run:

```bash
make run-old-detached
```


To run the `certtest:new` image in detached mode, run:

```bash
make run-new-detached
```

### Shut Down Container

```bash
make remove
```

### Cleaning Up

To remove all resources (containers, networks, volumes, and images) related to this project, run:
```bash
make purge
```

This will also remove dangling images, volumes, and build cache to free up disk space. Use this when you're completely done.