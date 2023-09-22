# Certbot Testing

Bug has been identifed! https://github.com/cloudflare/python-cloudflare/issues/172

Presence of `CLOUDFLARE_EMAIL` env variable causes the Cloudflare library to defail to using an API key instead of a token.

Fix: Renamed `CLOUDFLARE_EMAIL` to `FE_NOTIFY_EMAIL` and working as expected.

~~The current official builds don't seem to work due to an issue with the python-cloudflare package.~~  
**_(Warning: This container should NOT be used in production without additional testing.)_**

## Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Variables](#environment-variables)
- [Make Commands](#make-commands)
  - [Building Images](#building-images)
  - [Running Containers](#running-containers)
  - [Cleaning Up](#cleaning-up)
- [Testing](#Testing)
- [Expected Results](#expected-results)

## Prerequisites

- Docker
- Docker Compose
- GNU Make
- Valid Cloudflare API token with "Edit zone DNS" rights to the domain you are requesting an SSL certificate for.

## Environment Variables

Required environment variables:

- `CLOUDFLARE_TOKEN`: Cloudflare token with appropriate permissions (NOT an API key).
- `CLOUDFLARE_DOMAIN_LIST`: List of domains to register in certbot's expected format, e.g.:
  - `"domain.com"` for a single domain
  - `"*.domain.com -d test.domain.com"` for multiple domains with a wildcard
- `FE_NOTIFY_EMAIL`: Email to register domain with.

Can be provided with an .env file in the following format:

```
CLOUDFLARE_TOKEN="abcdefghigjl123456789"
CLOUDFLARE_EMAIL="email@domain.com"
CLOUDFLARE_DOMAIN_LIST="test@domain.com"
```

## Make Commands

For simpler and consistent testing, a Makefile is included:

- `make all`: Build both `certtest:new` and `certtest:old` images.
- `make build-new`: Build the `certtest:new` image.
- `make build-old`: Build the `certtest:old` image.
- `make run-new`: Run the `certtest:new` image.
- `make run-old`: Run the `certtest:old` image.
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

To run the `certtest:new` image, run:

```bash
make run-new
```

To run the `certtest:old` image, run:
```bash
make run-old
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

## Testing

```
make all
make run-new
make run-old
make remove
```


## Expected Results

When running the new container:

```
[+] Running 3/0
 ✔ Network certbot-cf-dns_default      Created                                                                                             0.1s 
 ✔ Volume "certbot-cf-dns_ssl_certs"   Created                                                                                             0.0s 
 ✔ Container certbot-cf-dns-certbot-1  Created                                                                                             0.0s 
Attaching to certbot-cf-dns-certbot-1
certbot-cf-dns-certbot-1  | Saving debug log to /var/log/letsencrypt/letsencrypt.log
certbot-cf-dns-certbot-1  | Account registered.
certbot-cf-dns-certbot-1  | Requesting a certificate for test.domain.com
certbot-cf-dns-certbot-1  | Error determining zone_id: 6003 Invalid request headers. Please confirm that you have supplied valid Cloudflare API credentials. (Did you copy your entire API token/key? To use Cloudflare tokens, you'll need the python package cloudflare>=2.3.1. This certbot is running cloudflare 2.11.7)
certbot-cf-dns-certbot-1  | Ask for help or search for solutions at https://community.letsencrypt.org. See the logfile /var/log/letsencrypt/letsencrypt.log or re-run Certbot with -v for more details.
certbot-cf-dns-certbot-1 exited with code 1
```

When running the old container:
```
[+] Running 1/0
 ✔ Container certbot-cf-dns-certbot-1  Recreated                                                                                           0.0s 
Attaching to certbot-cf-dns-certbot-1
certbot-cf-dns-certbot-1  | Saving debug log to /var/log/letsencrypt/letsencrypt.log
certbot-cf-dns-certbot-1  | Requesting a certificate for test.domain.com
certbot-cf-dns-certbot-1  | Waiting 30 seconds for DNS changes to propagate
certbot-cf-dns-certbot-1  | 
certbot-cf-dns-certbot-1  | Successfully received certificate.
certbot-cf-dns-certbot-1  | Certificate is saved at: /etc/letsencrypt/live/test.domain.com/fullchain.pem
certbot-cf-dns-certbot-1  | Key is saved at:         /etc/letsencrypt/live/test.domain.com/privkey.pem
certbot-cf-dns-certbot-1  | This certificate expires on 2023-12-15.
certbot-cf-dns-certbot-1  | These files will be updated when the certificate renews.
certbot-cf-dns-certbot-1  | NEXT STEPS:
certbot-cf-dns-certbot-1  | - The certificate will need to be renewed before it expires. Certbot can automatically renew the certificate in the background, but you may need to take steps to enable that functionality. See https://certbot.org/renewal-setup for instructions.
certbot-cf-dns-certbot-1  | 
certbot-cf-dns-certbot-1 exited with code 0
```