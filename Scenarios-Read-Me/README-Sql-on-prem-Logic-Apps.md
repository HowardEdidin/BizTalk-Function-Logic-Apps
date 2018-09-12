## SQL on-prem to Logic Apps

#### Links

These will describe some of the concepts that we're using in this scenario.

1. [Install SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017)
1. [Run Docker SQL Server Image](https://hub.docker.com/r/microsoft/mssql-server-windows-developer/)
1. [Using Logic Apps Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-connection)
1. [Install Logic Apps Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-install)

#### Set up environment

Run a docker image for sql
```
docker run -d -p 1433:1433 -e sa_password=<SA_PASSWORD> -e ACCEPT_EULA=Y microsoft/mssql-server-windows-developer
```

Start SQL Server Management studio and connect to the db.

Stand up some sample data
```

```
