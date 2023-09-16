###################################################################################################
# Dockerfile for Certbot / Cloudflare DNS testing
# Author: snk-nick
#  
# Required environment variables:
# CLOUDFLARE_TOKEN: Cloudflare token with appropriate permissions (NOT an API key).
# CLOUDFLARE_EMAIL: Email to register domain with.
# CLOUDFLARE_DOMAIN_LIST: List of domains to register in certbots expected format, eg:
#                         "domain.com"                       - Single domain
#                         "*.domain.com -d test.domain.com"  - Multiple with wildcard
###################################################################################################

# Build arguments
ARG IMAGE=certbot/dns-cloudflare
ARG TAG=v2.6.0

# Package version arguments. 
ARG CLOUDFLARE_VERSION=2.8.15 

# Pull the base image
FROM ${IMAGE}:${TAG}

# Init version args/envs
ARG CLOUDFLARE_VERSION

# Install Python packages via pip
RUN pip install --no-cache-dir cloudflare==${CLOUDFLARE_VERSION}

# Copy init script
COPY init-certbot.sh /init-certbot.sh
RUN chmod +x /init-certbot.sh

# Runs the init-certbot script on launch, output to stdout
ENTRYPOINT ["/bin/sh", "-c", "/init-certbot.sh"]
#ENTRYPOINT ["/bin/sh", "-c", "trap exit TERM; while :; do /init-certbot.sh >> /var/log/certbot.log 2>&1; sleep 12h & wait ${!}; done"]