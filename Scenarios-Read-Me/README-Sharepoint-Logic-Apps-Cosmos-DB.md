## Pull an item from SharePoint and store in Cosmos DB with Logic Apps

### Links

These will describe some of the concepts that we're using in this scenario.

1. [Cosmos DB - Mongo DB](https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb-introduction)
1. [Pre-Migration Cosmos DB for Mongo DB](https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb-pre-migration)
1. [Post-Migration Cosmos DB for Mongo DB](https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb-post-migration)
1. [Azure Functions Overview](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)
1. [SharePoint Logic App Connector](https://docs.microsoft.com/en-us/azure/connectors/connectors-create-api-sharepoint)
1. [Logic App Data Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-install)
1. [Connect to On Prem Data with Logic App Data Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-connection)
1. [Data Explorer](https://docs.microsoft.com/en-us/azure/cosmos-db/data-explorer)
1. [Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/)

### Scenario

We'll use a logic app to pull from items SharePoint and use the Cosmos DB Connector to pass them over to Cosmos DB.

![Scenario](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/sp-scenario.png 'Scenario')

> We could extend this other data sources, and also account for other activities (like Delete / Modify).  For now, we'll work on Add.

We will also assume that we can set up a Cosmos DB to call.

We will also assume that we have an Azure Function App that we can call.

#### Create a Cosmos DB

We'll want to spin up a Cosmos DB, which we can find in the [Azure Portal](portal.azure.com).

![Create Cosmos DB](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/create-cosmos-db-0.png 'Create Cosmos DB')

Review the Cosmos configuration before submitting.

![Create Cosmos DB](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/create-cosmos-db-1.png 'Create Cosmos DB')

Once the deployment has finished, we can hop into Cosmos DB and check the Data Explorer.  Here, we can provision a DB and a collection for testing.

![Create Cosmos DB Collection](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/create-cosmos-db-2.png 'Create Cosmos DB Collection')

> Fixed size will not require a partition key.  Unlimited requires a partition key.  The partition key will help with balancing the documents.  We can assume fixed size for now.  Also, the document id in JSON should look like '_id'.

#### Create Azure Function App

We will want to transform the data that we're receiving from the SharePoint Connector.

We'll now create an Azure Function App in the [Azure Portal](portal.azure.com).

> Pick a language.  In this scenario, we're using Javascript, but this could be C# or Python too.

![Create Azure Function App](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/create-azure-function-0.png 'Create Azure Function App')

In the Azure function app, let's create a new function.

![Create Azure Function](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/create-azure-function-1.png 'Create Azure Function')

Name the function and create it.

![Name Azure Function](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/create-azure-function-2.png 'Name Azure Function')

Add in the appropriate script, save, and run the app.

![Add Script](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/create-azure-function-3.png 'Add Script')

If we want, we can also attempt to trigger the Function app.  We can use the URL from the HTTP Trigger for the Azure Function.

![Copy Azure Function URL](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/create-azure-function-4.png 'Copy Azure Function URL')

We can verify with Postman.

![Copy Azure Function URL](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/create-azure-function-5.png 'Copy Azure Function URL')

Or we can then submit to the function app using Powershell.

```powershell
curl -v -method post -uri "https://{functionapp}.azurewebsites.net/api/{functionname}?code={functionappkey}" -H @{'Content-Type' = 'application/json'} -body @{'some JSON'}
```

#### Create Logic App using SharePoint Connector
We'll now create a logic app in the portal to validate that we can read an item from SharePoint and then send it to Cosmos DB using the Cosmos DB Connector.

![Create a Logic App](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/create-logic-app.png 'Create A Logic App')

We'll use a trigger in the logic app.  In this case, we'll use a SharePoint Connector.

![SharePoint Trigger](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/sharepoint-trigger-0.png 'SharePoint Trigger')

Select the appropriate trigger.

![SharePoint Trigger](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/sharepoint-trigger-1.png 'SharePoint Trigger')

Select the appropriate SharePoint site and list.

![SharePoint Trigger](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/sharepoint-trigger-2.png 'SharePoint Trigger')

Assuming that we can resolve to SharePoint, we can check the dropdown and select the appropriate list.

> For SharePoint on-prem, we may need to use the Logic App Data Gateway in order to reach on-prem.   For this we'll need to [install a Logic App Data Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-install) and [Connect to On Prem Data with a Logic App Data Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-connection).  As of right now, there isn't an ISE SharePoint Connector.  If we're using SharePoint online, we should be able to authenticate to SharePoint and resolve to it.

We'll now add a function to transform what we get back from SharePoint.

![Add Azure Function](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/add-azure-function-0.png 'Add Azure Function')

We want to ensure that we have an Azure Function created in the subscription.

![Add Azure Function](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/add-azure-function-1.png 'Add Azure Function')

We will want to use an Azure Function with an HTTP Trigger.

> If we haven't already created an Azure Function, we can go ahead and add it to the subscription.  Please refer to the [Transform JS](../FunctionApps/SharePoint-Logic-Apps-Cosmos-DB/index.js) that we can use in the function app.  We could also expand this js to handle additional scenarios **beyond add, like update/modify, and delete**.  Also, this version of the javascript will assume that there's an item with a property called **Title**.

![Add Azure Function](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/add-azure-function-2.png 'Add Azure Function')

We can now add in the SharePoint item from the dynamic content into the Azure Function.

![Add input to Azure Function](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/add-azure-function-3.png 'Add input to Azure Function')

We can now add a Cosmos DB Connector to create a document.

![Add Cosmos DB Connector](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/connect-cosmos-db-0.png 'Add Cosmos DB Connector')

Let's select the Cosmos DB Action to create a document.

![Select Cosmos DB action](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/connect-cosmos-db-1.png 'Select Cosmos DB action')

Select the Cosmos DB connection.

> In this case we can find the one that's already in our subscription.  We also have an option to manually input a connection string too.

![Select Cosmos DB connection](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/connect-cosmos-db-2.png 'Select Cosmos DB connection')

We can now pass in the output of the Azure Function to the Cosmos DB connector.  Be sure to include the appropriate DB and collection ID.

> Also be sure that the JSON document includes a '_id' property. 

![Configure Cosmos DB Connector](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/connect-cosmos-db-3.png 'Configure Cosmos DB Connector')

Now, we can add in one more action for Cosmos DB to Read All Documents.

![Read Cosmos DB](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/read-cosmos-db-0.png 'Read Cosmos DB')

We can select the appropriate DB and collection, assuming that the Cosmos DB is available.

![Read Cosmos DB](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/read-cosmos-db-1.png 'Read Cosmos DB')

### Verify the Steps

We'll want to trigger the logic app next.

![Run Logic App](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/verify-logic-app-0.png 'Run Logic App')

Assuming we can modify or create an item in the SharePoint list, we can then trigger the logic app.

We can review the details of each step.  For prior runs, we can also view the run history.

![Run History Logic App](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/verify-logic-app-run-history.png 'Run History Logic App')

Check the SharePoint step.

![Check SharePoint](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/verify-logic-app-1.png 'Check SharePoint')

Check the transform Azure Function.  We should get a 200.

![Check transform Azure Function](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/verify-logic-app-2.png 'Check transform Azure Function')

We can verify that the contents of the JSON document are sent over to Cosmos DB.

![Check Cosmos DB Send](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/verify-logic-app-3.png 'Check Cosmos DB Send')

We can read all documents from Cosmos DB.

> Alternatively, we can browse the [Data Explorer](https://docs.microsoft.com/en-us/azure/cosmos-db/data-explorer) in the portal, or use [Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/).

![Read documents from Cosmos DB](../Media/Scenario-Sharepoint-Logic-Apps-Cosmos-DB/verify-logic-app-4.png 'Read documents from Cosmos DB')


