# SPT Server Docker

用于在 Docker 中运行 SPT 4.0.13 服务端。本仓库包含 Docker 配置、`SPT/SPT.Server.Linux` 和 `SPT/SPT_Data/`；游戏客户端和启动器仍然在你的电脑上运行。

## 前置要求

- Intel/AMD x86_64 主机。`SPT/SPT.Server.Linux` 不适合 ARM 架构的群晖 NAS。
- Docker Compose 或群晖 Container Manager。
- SPT 4.0.13 服务端目录，目录名必须是 `SPT/`。

构建镜像前，需要把完整的 `SPT/` 目录放到 `Dockerfile` 同级目录。本仓库已经包含 `SPT.Server.Linux` 和 `SPT_Data`，但仍需要补齐 `SPT/` 目录中的其他 DLL、`.deps.json`、`.runtimeconfig.json` 等文件：

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

## 群晖 NAS 部署

1. 把本仓库目录复制到 NAS。
2. 把你的 `SPT/` 服务端目录复制到 `Dockerfile` 同级目录。
3. 编辑 `docker-compose.yml`。
4. 把 `SPT_BACKEND_IP` 改成你的 NAS 局域网 IP，例如：

```yaml
SPT_BACKEND_IP: 192.168.1.20
```

5. 在群晖 Container Manager 中以 Compose 项目启动。

如果你习惯用 SSH，也可以在目录内执行：

```sh
docker compose up -d --build
```

启动后，电脑上的客户端应连接：

```text
http://<NAS局域网IP>:6969
```

## 本地运行

```sh
docker compose up -d --build
```

服务端监听地址：

```text
http://127.0.0.1:6969
```

## 持久化数据

`./spt-user` 会挂载到容器内的 `/app/user`。重建、升级或替换镜像时，请保留这个目录。

Compose 配置里对应的是：

```yaml
volumes:
  - ./spt-user:/app/user
```

## 环境变量

| 变量 | 默认值 | 说明 |
| --- | --- | --- |
| `SPT_IP` | `0.0.0.0` | 容器内监听地址，保持 `0.0.0.0` 即可。 |
| `SPT_PORT` | `6969` | 容器内监听端口。 |
| `SPT_BACKEND_IP` | `127.0.0.1` | 返回给客户端的服务端地址。部署到群晖时必须改成 NAS 局域网 IP。 |
| `SPT_BACKEND_PORT` | `6969` | 返回给客户端的服务端端口。 |

容器启动时，`docker/entrypoint.sh` 会用这些环境变量更新 `SPT/SPT_Data/configs/http.json`。

## 升级说明

升级 SPT 时：

1. 停止容器。
2. 用新版本替换 `SPT/` 目录。
3. 保留 `./spt-user`。
4. 重新构建并启动：

```sh
docker compose up -d --build
```

## 常用命令

```sh
docker compose logs -f
docker compose restart
docker compose down
```
