FROM mcr.microsoft.com/dotnet/aspnet:10.0

WORKDIR /app
COPY SPT_Runtime/ /app/
COPY docker/entrypoint.sh /usr/local/bin/spt-entrypoint
RUN chmod +x /app/SPT.Server.Linux /usr/local/bin/spt-entrypoint \
    && mkdir -p /app/user

ENV SPT_IP=0.0.0.0 \
    SPT_PORT=6969 \
    SPT_BACKEND_IP=127.0.0.1 \
    SPT_BACKEND_PORT=6969
EXPOSE 6969
ENTRYPOINT ["spt-entrypoint"]
