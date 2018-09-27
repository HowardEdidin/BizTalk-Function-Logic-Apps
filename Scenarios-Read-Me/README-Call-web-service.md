## Calling Web Services
We can add different actions together as part of a logic app.  The conditions are based around results of prior steps.

#### Links

1. [Logic Apps Native HTTP Connector](https://docs.microsoft.com/en-us/azure/connectors/connectors-native-http)
1. [Using Azure Functions Logic App Connector](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-azure-functions)
1. [Secure APIs](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-custom-api-authentication)
1. [Create Custom APIs](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-create-api-app)
1. [Deploy Custom APIs](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-custom-api-host-deploy-call)
1. [Custom Connectors for APIs in Azure](https://docs.microsoft.com/en-us/azure/logic-apps/custom-connector-overview)

# Overall

We'll use the HTTP trigger and actions to get from a web service, then send an email.

![Overall](../Media/Scenario-Call-web-service/logic-app-call-webservice-overall.png 'Overall')

## Steps to the goal!

We'll use the Azure Portal to create a Logic App.

![Create a Logic App](../Media/Scenario-Call-web-service/create-logic-app.png 'Create A Logic App')

Create a trigger.  We'll use an HTTP trigger for now.

![Http Trigger](../Media/Scenario-Call-web-service/logic-app-trigger.png 'Create A Logic App Trigger')

Once the trigger is created, we'll still need to get an endpoint to hit the HTTP trigger.  We'll get that by saving the workflow.

![Http Trigger Step Created](../Media/Scenario-Call-web-service/logic-app-trigger-1.png 'Create A Logic App Trigger')

After saving, we'll have an HTTP Trigger URL.

![Http Trigger URL Generated](../Media/Scenario-Call-web-service/logic-app-trigger-2.png 'Create A Logic App HTTP Trigger')

## Create an HTTP Trigger.

We can call a web service.  In this case we'll use a simple get to call a web page.

![Configure HTTP Action](../Media/Scenario-Call-web-service/logic-app-call-webservice.png 'Configure HTTP Action')

## Send the result

We'll take the result and pass it along as an email.

![Configure Send Email](../Media/Scenario-Call-web-service/logic-app-send-email.png 'Configure Send Email')

## Testing the workflow

We'll want to save the workflow.  We can also test it to be sure that it will run.

![Save Workflow](../Media/Scenario-Call-web-service/logic-app-save-workflow.png 'Save Workflow')

Assuming that we're able to hit the endpoint, we should receive an email.

![Email Test](../Media/Scenario-Call-web-service/logic-app-email-test.png 'Email Test')

Given that we have an HTTP trigger in the beginning, we can try to send an HTTP request to the endpoint.

Copy the URL.

![Copy the URL](../Media/Scenario-Call-web-service/logic-app-trigger-url.png 'Copy the URL')

Pick a HTTP client of choice.  Perhaps curl, invoke-webrequest (Powershell), Postman, or even C# / Javascript code works too.

We can Powershell in this example.

In this case, we can have a simplified call.
```powershell
Invoke-WebRequest -Uri https://my.logic.azure.com/foobar -Method POST
```

Post to trigger the workflow.

![Post to Workflow](../Media/Scenario-Call-web-service/logic-app-call-webservice-post.png 'Post to Workflow')

We should be able to get an email with the response.

![Post to Workflow result](../Media/Scenario-Call-web-service/logic-app-call-webservice-post-result.png 'Post to Workflow Result')

