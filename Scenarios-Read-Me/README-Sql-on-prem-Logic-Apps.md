## SQL on-prem to Logic Apps

#### Links

These will describe some of the concepts that we're using in this scenario.

1. [Install SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017)
1. [Run Docker SQL Server Image](https://hub.docker.com/r/microsoft/mssql-server-windows-developer/)
1. [Using Logic Apps Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-connection)
1. [Install Logic Apps Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-install)
1. [Blog for Logic Apps and Gateway](https://blogs.biztalk360.com/access-on-premise-sql-server-data-from-azure-logic-apps-via-on-premises-data-gateway/)
1. [Using SQLCMD](https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-2017)
1. [Testing SQL on Windows Containers](https://cloudblogs.microsoft.com/sqlserver/2016/10/13/sql-server-2016-express-edition-in-windows-containers/)

#### Set up environment

Run a docker image for sql
```
docker run -d -p 1433:1433 -e sa_password=<SA_PASSWORD> -e ACCEPT_EULA=Y microsoft/mssql-server-windows-developer
```

Start SQL Server Management studio and connect to the db.
![Conect to DB.](../media/Scenario-Sql-on-prem-Logic-Apps/connect-db.png 'Connect to DB')

Stand up some sample data, run **.\Data\testdb.sql** in SQL Server Management Studio.  It should resemble something like the simplified script below:


```
CREATE DATABASE [testdb]

CREATE TABLE [dbo].[ContactType](
	[ID] [int] NOT NULL,
	[ContactType] [nvarchar](50) NULL,
 CONSTRAINT [PK_ContactType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[ContactType] TO  SCHEMA OWNER 
GO
INSERT [dbo].[ContactType] ([ID], [ContactType]) VALUES (1, N'Accounting Manager')
```

We can use SQLCMD to test connectivity to the running container and verify the table is populated.  We can obtain the server name from ipconfig, which will be the **host machine's IP**.  SQLCMD uses the -S flag for Server, -U for the user, and -P for the password.

![Contact Types.](../media/Scenario-Sql-on-prem-Logic-Apps/sample-data.png 'Contact Types')

##### Enable Firewall Port for SQL

```
netsh advfirewall firewall add rule name = SQLPort1 dir = in protocol = tcp action = allow localport = 1433 remoteip = localsubnet profile = Public
```

#### Set up Application Gateway

Make sure to install the application gateway.  Once installed, we'll want to create the corresponding application gateway connection in Azure.

1. [Install Logic Apps Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-install)
1. [Using Logic Apps Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-connection)

Work through the installation wizard.
![Configure App Gatway.](../media/Scenario-Sql-on-prem-Logic-Apps/app-gateway-step-1.png 'Step 1')

Once the wizard is finished, we should be able to create a corresponding gateway.
![Wizard finished.](../media/Scenario-Sql-on-prem-Logic-Apps/app-gateway-step-2.png 'Step 2')

Create Connection Gateway in Azure.
![Create Conection Gateway.](../media/Scenario-Sql-on-prem-Logic-Apps/app-gateway-step-3.png 'Step 3')

Check Configuration for Connection Gateway in Portal.
![Check Configuration for Connection Gateway in Portal](../media/Scenario-Sql-on-prem-Logic-Apps/app-gateway-step-4.png 'Step 4')

#### Create A Logic App

We'll now create a logic app.
![Create a Logic App](../media/Scenario-Sql-on-prem-Logic-Apps/create-logic-app-1.png 'Create A Logic App')

We'll use a trigger in the logic app.  In this case, we'll just set up recurrence for testing.
![Recurrence Trigger](../media/Scenario-Sql-on-prem-Logic-Apps/logic-app-config-step-1.png 'Recurrence Trigger')

We can now add another action for the trigger.  In this case, we'll use SQL get rows.  Note that the server name in this case is the sql server host.  We'll use the container host name.

Run this on the host
```
$env:computername
```

Configure the SQL Connection
![Configure SQL Connection](../media/Scenario-Sql-on-prem-Logic-Apps/logic-app-config-step-2.png 'Configure SQL Connection')

Set which table to use for 'Get Rows'
![Get Rows](../media/Scenario-Sql-on-prem-Logic-Apps/logic-app-config-step-3.png 'Get Rows')

Click on Save Button, then run the application, then view the designer.
Set which table to use for 'Get Rows'
![Run a test](../media/Scenario-Sql-on-prem-Logic-Apps/logic-app-config-step-4.png 'Run a test')

We'll be able to check the results of the step.

Set which table to use for 'Get Rows'
![Validate Result](../media/Scenario-Sql-on-prem-Logic-Apps/logic-app-config-step-5.png 'Validate Results')