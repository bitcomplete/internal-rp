# internal-rp

## Overview

internal-rp is a configurable reverse proxy for managing access to internal
services such as dashboards. It consists of an nginx-based Docker image that can
be configured solely by environment variables. Access to services is allowed
only for users authenticated via [OAuth2
Proxy](https://oauth2-proxy.github.io/oauth2-proxy/).

Services can consist of **backend services** which are HTTP servers reachable by
internal-rp, and **static services** which are static files living in GCS. An
example with four services, two backend and two static, is shown below:

```
    USER                   ┌───────────┐
             authenticated │           │
      │          routes    │           │
      │             ┌─────►│ static_1/ │ static_1.internal.xyz.com
      │             │      │           │
internal.xyz.com    │      │           │
      │             ├─────►│ static_2/ │ static_2.internal.xyz.com
      │             │      │           │
      ▼             │      │           │
┌─────────────┐     │      └───────────┘
│             │     │         bucket
│ internal-rp ├─────┤
│             │     │      ┌───────────┐
└───┬─────────┘     │      │           │
    │    ▲          ├─────►│ backend_1 │ backend_1.internal.xyz.com
    │    │          │      │           │
    │    │          │      └───────────┘
    ▼    │          │
┌────────┴────┐     │      ┌───────────┐
│   oauth     │     │      │           │
│  provider   │     └─────►│ backend_2 │ backend_2.internal.xyz.com
│             │            │           │
└─────────────┘            └───────────┘
```

In this example, the proxy is directly accessible at internal.xyz.com and it
will produce a simple web page with links to each of the services. The services
are accessible at subdomains of internal.xyz.com as shown. Users will not be
able to access the proxy web page or any of the services until they have
authenticated with the OAuth provider, and once authenticated they will be able
to freely access all of these services.

## Configuration

The Docker image is configured solely by environment variables. These are
outlined below.

**Required environment variables:**

* `PORT` - Ingress port for the proxy.
* `ROOT_DOMAIN` - Root domain under which services will be exposed as
  subdomains.

**Per-service environment variables:**

Each of these variables can be repeated with indexes starting at 1.

* `SERVICE_i` - The i'th service name. This service will be accessible at this
  subdomain of root.
* `BACKEND_i` - The base URL of a backend service to proxy for the
  i'th service.
* `BUCKET_PREFIX_i` - The GCS bucket prefix for the i'th service.

The proxy illustrated above would be configured with these env vars:

```
SERVICE_1=static_1
BUCKET_PREFIX_1=bucket/static_1
SERVICE_2=static_2
BUCKET_PREFIX_2=bucket/static_2
SERVICE_3=backend_1
BACKEND_3=http://backend_1
SERVICE_4=backend_2
BACKEND_4=http://backend_2
```

Note that only one of BUCKET_PREFIX_i or BACKEND_i for a given i should be
specified.

**Required OAuth environment variables:**

* `OAUTH2_PROXY_CLIENT_ID` - OAuth client ID.
* `OAUTH2_PROXY_CLIENT_SECRET` - OAuth client secret.
* `OAUTH2_PROXY_COOKIE_SECRET` - 32 character signing secret.
* `OAUTH2_PROXY_EMAIL_DOMAINS` - Email domain for allowed users.

By default OAuth2 Proxy assumes Google is the auth provider. For more details
About OAuth2 Proxy see their [provider configuration
docs](https://oauth2-proxy.github.io/oauth2-proxy/docs/configuration/oauth_provider).

**Optional environment variables:**

* `DASHBOARD_DOMAIN` - The domain for the dashboard/OAuth server. Defaults to
  ROOT_DOMAIN.

## Release process

Make sure that the git repo is clean and up to date with origin/main. Then run:

```
(read -r v && git tag -a v$v -m v$v && git push origin v$v)
```
