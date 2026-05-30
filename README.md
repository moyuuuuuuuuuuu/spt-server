# SPT Server Docker

Run the SPT 4.0.13 server in Docker. This repository contains Docker files only; the game client and launcher still run on your PC.

## Requirements

- Intel/AMD x86_64 host. `SPT/SPT.Server.Linux` is not suitable for ARM Synology NAS models.
- Docker Compose or Synology Container Manager.
- The SPT 4.0.13 server folder named `SPT/`.

Before building, place the `SPT/` folder next to `Dockerfile`:

```text
spt-server/
  Dockerfile
  docker-compose.yml
  docker/
    entrypoint.sh
  SPT/
    SPT.Server.Linux
    SPT_Data/
```

## Synology NAS

1. Copy this repository folder to the NAS.
2. Copy your `SPT/` server folder into the same directory as `Dockerfile`.
3. Edit `docker-compose.yml`.
4. Set `SPT_BACKEND_IP` to your NAS LAN IP:

```yaml
SPT_BACKEND_IP: 192.168.1.20
```

5. Start the stack in Synology Container Manager as a Compose project.

If you prefer SSH:

```sh
docker compose up -d --build
```

After startup, the server should be reachable from your PC at:

```text
http://<NAS_LAN_IP>:6969
```

## Local Run

```sh
docker compose up -d --build
```

The server listens on:

```text
http://127.0.0.1:6969
```

## Persistent Data

`./spt-user` is mounted to `/app/user` inside the container. Keep this folder when rebuilding, updating, or replacing the image.

The compose file uses:

```yaml
volumes:
  - ./spt-user:/app/user
```

## Environment Variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `SPT_IP` | `0.0.0.0` | Container listen address. Keep this as `0.0.0.0`. |
| `SPT_PORT` | `6969` | Container listen port. |
| `SPT_BACKEND_IP` | `127.0.0.1` | Address returned to the client. On Synology, set this to the NAS LAN IP. |
| `SPT_BACKEND_PORT` | `6969` | Backend port returned to the client. |

The entrypoint updates `SPT/SPT_Data/configs/http.json` on container startup using these values.

## Upgrade Notes

When upgrading SPT:

1. Stop the container.
2. Replace the `SPT/` folder with the new server version.
3. Keep `./spt-user`.
4. Rebuild and start:

```sh
docker compose up -d --build
```

## Useful Commands

```sh
docker compose logs -f
docker compose restart
docker compose down
```
