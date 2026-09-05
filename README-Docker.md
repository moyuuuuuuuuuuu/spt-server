# SPT Docker

This image runs the SPT 4.1.3 server only, using ASP.NET Core 10. The game client and launcher still run on your PC.

Place the complete `SPT_Runtime/` server folder next to the Dockerfile before building. Server binaries are not included in this repository.

## Local Run

```sh
cp .env.example .env
docker compose up -d --build
```

On Windows PowerShell, use `Copy-Item .env.example .env` to copy the template.

Connect to `https://127.0.0.1:6969`. SPT 4.1.3 generates a self-signed HTTPS certificate on first startup, so browsers may show a certificate warning.

## Synology NAS Run

1. Copy the Docker configuration and complete `SPT_Runtime/` folder to the NAS.
2. Copy `.env.example` to `.env`.
3. Set `SPT_BACKEND_IP` in `.env` to the NAS LAN IP, for example `192.168.1.20`.
4. Start the Compose project in Container Manager, or run `docker compose up -d --build` over SSH.

Connect clients to `https://<NAS_LAN_IP>:6969`.

## Ports

`SPT_PORT` in `.env` controls the host port and the port advertised to clients. The container always listens on port 6969. Use `SPT_PORT=6970` if another server already occupies 6969, then connect to `https://<NAS_LAN_IP>:6970`.

The Compose project is named `spt-413`; the image is `spt-server:4.1.3`.

## Persistent Data

`./spt-user` is mounted to `/app/user`, preserving profiles, server mods, logs, and certificates. Keep this folder when rebuilding the image. Existing 4.1.3 data from `SPT_Runtime/user/` must be copied to `spt-user/` before the first startup; it is not included in the image or copied automatically.

Install compatible server mods in `spt-user/mods/` and restart. Keep 4.0.13 and 4.1.3 user directories separate; back up data and verify compatibility before migrating between versions.

## CPU Architecture

This configuration targets Linux x86_64 (Intel/AMD NAS models). It does not provide a native ARM image.
