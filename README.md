# Certbot Testing

The current official builds don't seem to work due to an issue with the python-cloudflare package.  
**_(Warning: This container should NOT be used in production without additional testing.)_**

## Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Variables](#environment-variables)
- [Make Commands](#make-commands)
  - [Building Images](#building-images)
  - [Running Containers](#running-containers)
  - [Cleaning Up](#cleaning-up)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- Docker
- Docker Compose
- GNU Make

## Environment Variables

Required environment variables:

- `CLOUDFLARE_TOKEN`: Cloudflare token with appropriate permissions (NOT an API key).
- `CLOUDFLARE_EMAIL`: Email to register domain with.
- `CLOUDFLARE_DOMAIN_LIST`: List of domains to register in certbot's expected format, e.g.:
  - `"domain.com"` for a single domain
  - `"*.domain.com -d test.domain.com"` for multiple domains with a wildcard

## Make Commands

For simpler and consistent testing, a Makefile is included:

- `make all`: Build both `certtest:old` and `certtest:new` images.
- `make build-old`: Build the `certtest:old` image.
- `make build-new`: Build the `certtest:new` image.
- `make run-old`: Run the `certtest:old` image.
- `make run-new`: Run the `certtest:new` image.
- `make run-old-detached`: Run the `certtest:old` image in detached mode.
- `make run-new-detached`: Run the `certtest:new` image in detached mode.
- `make remove`: Remove containers.
- `make purge`: Remove all resources (containers, networks, volumes, and images) related to this project.

### Building Images

Build both `certtest:old` and `certtest:new` images, run:

```bash
make all
```

Build only the `certtest:old` image, run:

```bash
make build-old
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

### Remove Container

```bash
make remove
```

### Cleaning Up

To purge all resources (containers, networks, volumes, and images) related to this test, run:
```bash
make purge
```