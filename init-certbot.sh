#!/bin/sh
# Creates the required .ini file for cloudflare-dns and obtains/renews certificates

# Create the authentication .ini
echo "dns_cloudflare_api_token = $CLOUDFLARE_TOKEN" > /cloudflare.ini
chmod 600 /cloudflare.ini

# Run certbot
certbot certonly \
    --dns-cloudflare \
    --dns-cloudflare-credentials /cloudflare.ini \
    --dns-cloudflare-propagation-seconds 30 \
    --agree-tos \
    --no-eff-email \
    --staging \
    -n \
    -m $CLOUDFLARE_EMAIL \
    -d $CLOUDFLARE_DOMAIN_LIST