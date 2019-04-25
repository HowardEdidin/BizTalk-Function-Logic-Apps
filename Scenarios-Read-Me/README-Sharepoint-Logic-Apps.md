## Pull an item from SharePoint and store in QNA Maker with Logic Apps

### Links

These will describe some of the concepts that we're using in this scenario.

1. [QNA Maker](https://www.qnamaker.ai/)
1. [QNA Maker API](https://westus.dev.cognitive.microsoft.com/docs/services/5a93fcf85b4ccd136866eb37/operations/5ac266295b4ccd1554da7600)
1. [QNA from SharePoint Blog](https://medium.com/@AliMazaheri/updating-qna-maker-knowledge-base-via-sharepoint-online-using-logic-apps-9a6f1f1bb4ab
)
1. [Azure Functions Overview](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)
1. [SharePoint Logic App Connector](https://docs.microsoft.com/en-us/azure/connectors/connectors-create-api-sharepoint)
1. [Logic App Data Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-install)
1. [Connect to On Prem Data with Logic App Data Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-connection)
1. [QNA Maker Overview](https://docs.microsoft.com/en-us/azure/cognitive-services/qnamaker/overview/overview)

### Scenario

We'll use a logic app to pull from items SharePoint and use the QNA Maker REST API to pass them over to QNA maker.

![Scenario](../Media/Scenario-Sharepoint-Logic-Apps/sp-scenario.png 'Scenario')

> We could extend this other data sources, and also account for other activities (like Delete / Modify).  For now, we'll work on Add.

We will also assume that we have created a [QNA Maker](https://docs.microsoft.com/en-us/azure/cognitive-services/qnamaker/overview/overview).

#### Create Logic App using SharePoint Connector
We'll now create a logic app in the portal to validate that we can read an item from SharePoint and then send it to QNA Maker using the REST API.

![Create a Logic App](../Media/Scenario-Sharepoint-Logic-Apps/create-logic-app.png 'Create A Logic App')

We'll use a trigger in the logic app.  In this case, we'll use a SharePoint Connector.

![SharePoint Trigger](../Media/Scenario-Sharepoint-Logic-Apps/sharepoint-trigger-0.png 'SharePoint Trigger')

Select the appropriate trigger.

![SharePoint Trigger](../Media/Scenario-Sharepoint-Logic-Apps/sharepoint-trigger-1.png 'SharePoint Trigger')

Select the appropriate SharePoint site and list.

![SharePoint Trigger](../Media/Scenario-Sharepoint-Logic-Apps/sharepoint-trigger-2.png 'SharePoint Trigger')

Assuming that we can resolve to SharePoint, we can check the dropdown and select the appropriate list.

> For SharePoint on-prem, we may need to use the Logic App Data Gateway in order to reach on-prem.   For this we'll need to [install a Logic App Data Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-install) and [Connect to On Prem Data with a Logic App Data Gateway](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-connection).  As of right now, there isn't an ISE SharePoint Connector.  If we're using SharePoint online, we should be able to authenticate to SharePoint and resolve to it.

We'll now add a function to transform what we get back from SharePoint.

![Add Azure Function](../Media/Scenario-Sharepoint-Logic-Apps/add-azure-function-0.png 'Add Azure Function')

We want to ensure that we have an Azure Function created in the subscription.

![Add Azure Function](../Media/Scenario-Sharepoint-Logic-Apps/add-azure-function-1.png 'Add Azure Function')

We will want to use an Azure Function with an HTTP Trigger.

> If we haven't already created an Azure Function, we can go ahead and add it to the subscription.  Please refer to the [Transform JS](../FunctionApps/SharePoint-Logic-Apps/index.js) that we can use in the function app.  We could also expand this js to handle additional scenarios **beyond add, like update/modify, and delete**.  Also, this version of the javascript will assume that there's an item with a property called **Title**.

![Add Azure Function](../Media/Scenario-Sharepoint-Logic-Apps/add-azure-function-2.png 'Add Azure Function')

We can now add in the SharePoint item from the dynamic content into the Azure Function.

![Add input to Azure Function](../Media/Scenario-Sharepoint-Logic-Apps/add-azure-function-3.png 'Add input to Azure Function')

We can now add in the HTTP Connector to PATCH on the [QNA Maker API](https://westus.dev.cognitive.microsoft.com/docs/services/5a93fcf85b4ccd136866eb37/operations/5ac266295b4ccd1554da7600).

> Given that this step asynchronously updates the knowledge base, we will also want to check on its status.  We can check in qnamaker.ai and verify by looking at the knowledge base.  Also, we'll want to publish the updates too. 

![Patch QNA Maker](../Media/Scenario-Sharepoint-Logic-Apps/qna-patch.png 'Patch QNA Maker')

We will now add in one more HTTP Connector to POST on the [QNA Maker API](https://westus.dev.cognitive.microsoft.com/docs/services/5a93fcf85b4ccd136866eb37/operations/5ac266295b4ccd1554da7600) to publish the changes.

![Post QNA Maker](../Media/Scenario-Sharepoint-Logic-Apps/qna-post.png 'Post QNA Maker')

### Verify the Steps

We'll want to trigger the logic app next.

![Run Logic App](../Media/Scenario-Sharepoint-Logic-Apps/verify-logic-app-0.png 'Run Logic App')

Assuming we can modify or create an item in the SharePoint list, we can then trigger the logic app.

We can review the details of each step.  For prior runs, we can also view the run history.

![Run History Logic App](../Media/Scenario-Sharepoint-Logic-Apps/verify-logic-app-run-history.png 'Run History Logic App')

Check the SharePoint step.

![Check SharePoint](../Media/Scenario-Sharepoint-Logic-Apps/verify-logic-app-1.png 'Check SharePoint')

Check the transform Azure Function.  We should get a 200.

![Check transform Azure Function](../Media/Scenario-Sharepoint-Logic-Apps/verify-logic-app-2.png 'Check transform Azure Function')

Check that we can send an updated question and answer to QNA Maker.  We should get a 202 and not started message.  Note that the update happens asynchronously and we can also verify on qnamaker.ai.

![Check patch qnamaker](../Media/Scenario-Sharepoint-Logic-Apps/verify-logic-app-3.png 'Check patch qnamaker')

We can also verify that the POST request was successful.  This will publish on QNA Maker.

![Check post qnamaker](../Media/Scenario-Sharepoint-Logic-Apps/verify-logic-app-4.png 'Check post qnamaker')

If we can navigate to the qnamaker.ai knowledge base, we can also see if the questions and answers made it.

![Check qnamaker](../Media/Scenario-Sharepoint-Logic-Apps/verify-logic-app-5.png 'Check qnamaker')

### Helpful Powershell Commands

Please verify the latest [QNA Maker API](https://westus.dev.cognitive.microsoft.com/docs/services/5a93fcf85b4ccd136866eb37/operations/5ac266295b4ccd1554da7600).

Check the QNA Maker knowledge base.
```powershell
$(curl -v -method GET -uri "https://westus.api.cognitive.microsoft.com/qnamaker/v4.0/knowledgebases/{kbid}/{env}/{name}" -H @{'Ocp-Apim-Subscription-Key' = '{subkey}'} -UseBasicParsing).Content
```

Update QNA Maker knowledge base.

```powershell
curl -v -method PATCH -uri "https://westus.api.cognitive.microsoft.com/qnamaker/v4.0/knowledgebases/{kbid}" -H @{'Ocp-Apim-Subscription-Key' = '{subkey}'; 'content-type'='application/json'} -body @{'some JSON'}
```

Publish QNA Maker knowledge base.

```powershell
curl -v -method post -uri "https://westus.api.cognitive.microsoft.com/qnamaker/v4.0/knowledgebases/{kbid}/" -H @{'Ocp-Apim-Subscription-Key' = '{subkey}'}
```

