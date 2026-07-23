# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

# Указываем реальную версию из релизов GitHub
ARG TT_VERSION="1.0.33"
ARG TARGETARCH

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl tar iproute2 && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    case "$TARGETARCH" in \
        amd64) TT_ARCH="x86_64" ;; \
        arm64) TT_ARCH="aarch64" ;; \
        *) echo "Unsupported TARGETARCH: $TARGETARCH"; exit 1 ;; \
    esac; \
    RELEASE_FILE="trusttunnel-v${TT_VERSION}-linux-${TT_ARCH}.tar.gz"; \
    curl -fsSL "https://github.com/TrustTunnel/TrustTunnel/releases/download/v${TT_VERSION}/${RELEASE_FILE}" -o /tmp/release.tar.gz; \
    mkdir -p /tmp/release; \
    tar -xzf /tmp/release.tar.gz -C /tmp/release; \
    # Копируем бинарники (учитывая возможную вложенность папок в архиве)
    cp /tmp/release/*/trusttunnel_endpoint /bin/ 2>/dev/null || cp /tmp/release/trusttunnel_endpoint /bin/; \
    cp /tmp/release/*/setup_wizard /bin/ 2>/dev/null || cp /tmp/release/setup_wizard /bin/; \
    rm -rf /tmp/release*

COPY --chmod=755 /docker-entrypoint.sh /scripts/

WORKDIR /trusttunnel_endpoint
VOLUME /trusttunnel_endpoint/

ENTRYPOINT ["/scripts/docker-entrypoint.sh"]
