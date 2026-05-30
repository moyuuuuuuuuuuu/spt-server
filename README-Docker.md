# SPT Docker

This image runs the SPT server only. The game client and launcher still run on your PC.

## Local Run

```sh
docker compose up -d --build
```

The server listens on `http://127.0.0.1:6969`.

## Synology NAS Run

1. Copy this folder to the NAS.
2. Edit `docker-compose.yml`.
3. Change `SPT_BACKEND_IP` to the NAS LAN IP, for example:

```yaml
SPT_BACKEND_IP: 192.168.1.20
```

4. Start it with Synology Container Manager as a Compose project, or over SSH:

```sh
docker compose up -d --build
```

The server will be available at:

```text
http://<NAS_LAN_IP>:6969
```

## Persistent Data

`./spt-user` is mounted to `/app/user` inside the container. Keep this folder when upgrading or rebuilding the image.

## CPU Architecture

`SPT/SPT.Server.Linux` is an `x86_64` Linux executable. This works on Intel/AMD Synology NAS models. ARM-based NAS models are not recommended for this package.
