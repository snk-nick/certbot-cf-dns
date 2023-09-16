###################################################################################################
# Dockerfile for Certbot / Cloudflare DNS testing
# Author: Nick Sandman
#  
# Required environment variables:
# CLOUDFLARE_TOKEN: Cloudflare token with appropriate permissions (NOT an API key).
# CLOUDFLARE_EMAIL: Email to register domain with.
# CLOUDFLARE_DOMAIN_LIST: List of domains to register in certbots expected format, eg:
#                         "domain.com"                       - Single domain
#                         "*.domain.com -d test.domain.com"  - Multiple with wildcard
#
# Configured as is it will obtain the certificate then wait 12 hours/attempt a renewal.
###################################################################################################

# Build arguments
ARG IMAGE=python
ARG TAG=3.11.5-slim

# Package version arguments. 
ARG CERTBOT_VERSION=2.6.0
ARG CERTBOT_DNS_VERSION=2.6.0
ARG CLOUDFLARE_VERSION=2.8.15

# Pull the base image
FROM ${IMAGE}:${TAG}
ENV DEBIAN_FRONTEND=non-interactive

LABEL org.opencontainers.image.authors="Nick Sandman <nick@snk.net.au>" \
      org.opencontainers.image.description="Certbot cloudflare-dns container." \
      org.opencontainers.image.version="0.1"

# Init version args/envs
ARG CERTBOT_VERSION
ARG CLOUDFLARE_VERSION
ARG CERTBOT_DNS_VERSION

# Install Python packages via pip
RUN pip install --no-cache-dir certbot==${CERTBOT_VERSION} certbot-dns-cloudflare==${CERTBOT_DNS_VERSION} cloudflare==${CLOUDFLARE_VERSION}

# Copy init script
COPY init-certbot.sh /init-certbot.sh
RUN chmod +x /init-certbot.sh

# Runs the init-certbot script on launch then every 12 hours afterwards. 
# Output is logged to /var/log/certbot.log
#CMD ["/bin/sh", "-c", "trap exit TERM; while :; do /init-certbot.sh >> /var/log/certbot.log 2>&1; sleep 12h & wait ${!}; done"]
CMD ["/bin/sh", "-c", "/init-certbot.sh"]