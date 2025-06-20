docker pull mcr.microsoft.com/mssql/server:2025-latest

docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=123" \
   -p 1433:1433 --name sql1 --hostname sql1 \
   -d \
   mcr.microsoft.com/mssql/server:2025-latest

# CREDS ARE:
# sa
# 123