# TrustTunnel
TrustTunnel docker image for Portainer Stacks

```yaml
services:
  trusttunnel:
    image: ghcr.io/octohare/trusttunnel:latest
    container_name: trusttunnel
    restart: unless-stopped
    network_mode: host # Используем сеть хоста напрямую
    volumes:
      # Монтируем ваши конфиги
      - /opt/trusttunnel/config:/trusttunnel_endpoint:rw
      # Монтируем сертификаты Caddy с хоста
      - /etc/caddy/data:/etc/caddy/data:ro
    healthcheck:
      # Проверяем, что процесс TrustTunnel держит открытым TCP-порт 8443
      test: ["CMD-SHELL", "ss -ltn | grep -q ':8443 '"]
      interval: 30s       # Проверять каждые 30 секунд
      timeout: 5s         # Таймаут на выполнение проверки
      retries: 3          # Пометить unhealthy после 3 неудач подряд
      start_period: 15s   # Дать 15 секунд на запуск при старте контейнера
```
