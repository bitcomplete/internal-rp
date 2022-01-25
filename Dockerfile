# Required environment variables:
#
# PORT
# ROOT_DOMAIN
# SERVICE_i
# BACKEND_i
# BUCKET_PREFIX_i
# OAUTH2_PROXY_CLIENT_ID
# OAUTH2_PROXY_CLIENT_SECRET
# OAUTH2_PROXY_COOKIE_SECRET
# OAUTH2_PROXY_EMAIL_DOMAINS

FROM nginx:1.21-alpine

ENV OAUTH2_PROXY_VERSION=7.2.1
ENV GCSPROXY_VERSION=0.3.0

RUN curl -sSL https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v${OAUTH2_PROXY_VERSION}/oauth2-proxy-v${OAUTH2_PROXY_VERSION}.linux-amd64.tar.gz | tar -xz -C /tmp \
  && cp /tmp/oauth2-proxy-v${OAUTH2_PROXY_VERSION}.linux-amd64/oauth2-proxy /usr/local/bin

RUN wget https://github.com/daichirata/gcsproxy/releases/download/v${GCSPROXY_VERSION}/gcsproxy_${GCSPROXY_VERSION}_amd64_linux -O /usr/local/bin/gcsproxy \
  && chmod +x /usr/local/bin/gcsproxy

COPY templates /templates
COPY docker-entrypoint.d/ /docker-entrypoint.d/
