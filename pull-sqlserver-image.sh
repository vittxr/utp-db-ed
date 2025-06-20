docker pull mcr.microsoft.com/mssql/server:2022-latest

docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Str0ngP@ssw0rd!" \
   -p 1433:1433 --name sql1 --hostname sql1 \
   -d \
   mcr.microsoft.com/mssql/server:2022-latest

# CREDS ARE:
# sa
# 123

# remove container 
docker rm sql1

# check logs:
docker ps -a --filter "name=sql1"
