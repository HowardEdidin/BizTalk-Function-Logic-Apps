## Calling Azure Functions

We can use Logic Apps to call Azure Functions.  Of course, if we want, we can also call into another endpoint that will trigger the Function (Blob, Queue, HTTP).  In this case, we'll use a function that has an HTTP trigger. 

#### Links

1. [Using Azure Functions Logic App Connector](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-azure-functions)
1. [Create Function App](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function)
1. [Create Function App inside a Logic App Designer](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-azure-functions#create-function-designer)
1. [Create Function App outside Logic App](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-azure-functions#create-function-external)
1. [Call Existing Function Apps](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-azure-functions#add-existing-functions-to-logic-apps)
1. [Call Logic Apps from Functions](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-http-endpoint)

# Create a Logic App

We'll use the Azure Portal to create a Logic App.

![Create a Logic App](../Media/Scenario-Call-Azure-Functions/create-logic-app.png 'Create A Logic App')

Create a trigger.  We'll use an HTTP trigger for now.

![Http Trigger](../Media/Scenario-Call-Azure-Functions/logic-app-trigger.png 'Create A Logic App Trigger')

Once the trigger is created, we'll still need to get an endpoint to hit the HTTP trigger.  We'll get that by saving the workflow.

![Http Trigger Step Created](../Media/Scenario-Call-Azure-Functions/logic-app-trigger-1.png 'Create A Logic App Trigger')

After saving, we'll have an HTTP Trigger URL.

![Http Trigger URL Generated](../Media/Scenario-Call-Azure-Functions/logic-app-trigger-2.png 'Create A Logic App HTTP Trigger')

# Create a Function App

We'll want to add a step to call an Azure Function.  We'll apply the steps from [Create Function App outside Logic App](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-azure-functions#create-function-external)
We'll create a function app.

![Create Function App](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app.png 'Create A Function App')

We'll create a function next.

![Create Function](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-1.png 'Create A Function App')

Add a code snippet.  When satisfied with the changes, please also save the function.

![Function Code Snippet](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-2.png 'Function code snippet')


```c#
#r "Newtonsoft.Json"

using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;
using Newtonsoft.Json;

public static async Task<IActionResult> Run(HttpRequest req, ILogger log)
{
    log.LogInformation("C# HTTP trigger function processed a request.");

    string name = req.Query["name"];

    string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
    dynamic data = JsonConvert.DeserializeObject(requestBody);
    name = name ?? data?.name;

    return name != null
        ? (ActionResult)new OkObjectResult($"Hello, {name}")
        : new BadRequestObjectResult("Please pass a name on the query string or in the request body");
}


```

We'll want to enable CORS.

![Enable CORS](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-3.png 'Enable CORS')

Under CORS, add the * wildcard character, but remove all the other origins in the list, and choose Save.

![Enable CORS Origins](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-4.png 'Enable CORS Origins')

## Select the Azure Function in Logic App

Back to the Logic App, we should be able to select the Azure Function.

![Select Azure Function](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-5.png 'Select Azure Function')

We can select which action to take with the function app.  We can also choose to [Create Function App inside a Logic App Designer](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-azure-functions#create-function-designer), but we'll use the one that we've already set up.

![Select Azure Function](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-6.png 'Select Azure Function')

We'll simply pass through the body of the prior step into the Azure Function.

![Select Azure Function](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-7.png 'Select Azure Function')

# Finish the Workflow

We'll borrow some of the concepts from [Conditionals and For Each](README-Conditional-for-each.md) and from [Sending Email](README-Send-email.md) in order to notify whether we had a successful call or not.

Let's add a new step.

![Create New Step](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-8.png 'Create New Step')

Let's add in the Outlook Office 365 API connector.

![Create Outlook Office 365 API Connector](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-9.png 'Create Outlook Office 365 API Connector')

We'll want to use the send email action.

![Send Email Action](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-10.png 'Send Email Action')

Configure the email for a succesful Function App call.

![Configure Send Email Action](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-11.png 'Configure Send Email Action')

We'll also want to configure the conditions to run this email action.

![Configure run after](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-12.png 'Configure run after')

We'll send an email if we're successful.

![Configure run after Condition](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-13.png 'Configure run after Condition')

## Handling another condition
We can add a second step for another condition.

![Add Parallel Branch](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-14.png 'Add Parallel Branch')

We can again find the Office 365 outlook API connector.

![Search for Send Email](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-15.png 'Search for Send Email')

Let's pick send an email for the Office 365 Outlook API.

![Search for Send Email Action](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-16.png 'Search for Send Email Action')

We'll want to configure the email contents.

![Configure Send Email Action](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-17.png 'Configure Send Email Action')

We'll want to configure the run after conditions.

![Configure Run After](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-18.png 'Configure Run After')

We'll want to set the conditions for the action.  In this case, we'll use fail and timeout.

![Configure Conditions](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-19.png 'Configure Conditions')

Click done to finish that step.

## Testing the workflow

We'll want to save and run the logic app.

![Save and Run Logic App](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-20.png 'Save and Run Logic App')

Given that we have an HTTP trigger in the beginning, we can try to send an HTTP request to the endpoint.

Copy the URL.

![Copy the URL](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-21.png 'Copy the URL')

Pick a HTTP client of choice.  Perhaps curl, invoke-webrequest (Powershell), Postman, or even C# / Javascript code works too.

We can Powershell in this example.  Here's an example post.

```powershell
$postParams = @{name='hellotest';moredata='qwerty'}
Invoke-WebRequest -Uri https://my.logic.azure.com/foobar -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
```

In this case, we can have a simplified call.
```powershell
$postParams = @{name='hellotest'}
Invoke-WebRequest -Uri https://my.logic.azure.com/foobar -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
```

We can test a working path.

![Successful Test Powershell](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-22.png 'Successful test Powershell')

And also a path that will fail.

![Failure Test Powershell](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-23.png 'Failure test Powershell')

We should have an email sent out to the effect.

In the successful test, we'll receive a friendly email.

![Successful Test Email](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-24.png 'Successful Test Email')

In the failure test, we'll receive an email with the issue.

![Failure Test Email](../Media/Scenario-Call-Azure-Functions/logic-app-create-function-app-25.png 'Failure Test Email')