# SPT Server Docker

运行 SPT 4.1.3 Linux 服务端，使用 .NET / ASP.NET Core 10。适用于 Intel/AMD x86_64 的 Docker 主机和群晖 NAS。游戏客户端、启动器及 BepInEx 客户端插件仍在电脑上运行。

本仓库只提供 Docker 配置，完整的 `SPT_Runtime/` 服务端文件需要自行获取，不随 Git 仓库提供。

## 前置要求

- Intel/AMD x86_64 主机。
- Docker Compose 或群晖 Container Manager。
- 完整的 SPT 4.1.3 服务端目录 `SPT_Runtime/`。

```text
spt-server/
  Dockerfile
  docker-compose.yml
  docker/
    entrypoint.sh
  SPT_Runtime/
    SPT.Server.Linux
    SPT_Data/
```

## 群晖 NAS / Linux 部署

将整个 `4.1.3` 目录复制到主机，保持 `SPT_Runtime/` 与 `Dockerfile` 同级。该目录必须包含完整服务端文件，包括 `SPT.Server.Linux` 和 `SPT_Data/`。

在此目录执行：

```sh
cp .env.example .env
```

Windows PowerShell 使用 `Copy-Item .env.example .env`。编辑 `.env`，将 `SPT_BACKEND_IP` 改为 NAS/服务器局域网 IP，然后启动：

```sh
docker compose up -d --build
docker compose logs -f
```

群晖 Container Manager 也可用此目录创建 Compose 项目。客户端连接 `https://<服务器局域网IP>:6969`。本机默认连接 `https://127.0.0.1:6969`。

## 端口与两个版本同时运行

`.env` 的 `SPT_PORT` 是宿主机端口，容器内固定监听 6969，返回客户端的端口会同步更新。若 4.0.13 已占用 6969，将此版本的 `SPT_PORT` 设置为 `6970`，客户端相应连接 `https://<服务器局域网IP>:6970`。

Compose 项目名为 `spt-413`，镜像为 `spt-server:4.1.3`。

## 环境变量

| 变量 | 默认值 | 说明 |
| --- | --- | --- |
| `TZ` | `Asia/Shanghai` | 容器时区。 |
| `SPT_PORT` | `6969` | 宿主机端口，同时作为返回客户端的端口；容器内固定为 6969。 |
| `SPT_BACKEND_IP` | `127.0.0.1` | 返回客户端的主机地址，NAS 部署时改成 NAS 局域网 IP。 |

## 持久化数据与 Mods

`./spt-user` 挂载到 `/app/user`，保存该版本的用户数据和服务端 Mods。已有 4.1.3 用户数据可在首次启动前从 `SPT_Runtime/user/` 复制到 `spt-user/`；不会自动复制，也不会打包进镜像。服务端 Mods 放到 `spt-user/mods/`，安装后重启服务端，并确认支持 4.1.3。

4.0.13 与 4.1.3 使用各自目录下的 `spt-user`，不要让两个运行中的版本共用存档。跨版本迁移前备份并确认版本兼容性。

重建镜像时保留 `spt-user/`：

```sh
docker compose down
docker compose up -d --build
```

镜像只包含 `SPT_Runtime` 服务端内容，排除客户端启动器、自带 dotnet 目录、日志及用户数据。修改其他服务端配置后需要重新构建镜像；HTTP 地址和端口在启动时由环境变量写入容器配置。

4.1.3 默认使用 HTTPS，首次启动自动在 `spt-user/certs/` 生成自签名证书。浏览器首次访问可能提示证书不受信任；客户端地址也应填写 `https://`。

## 常用命令

```sh
docker compose logs -f
docker compose restart
docker compose down
```

英文部署说明见 [README-Docker.md](README-Docker.md)。
