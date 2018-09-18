## Conditional For Each
We can add different actions together as part of a logic app.  The conditions are based around results of prior steps.

#### Links

These will describe some of the concepts that we're using in this scenario.

1. [Control Flow - Conditionals](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-control-flow-conditional-statement)
1. [Control Flow - Switch](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-control-flow-switch-statement)
1. [Control Flow - Branches](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-control-flow-branches)
1. [Control Flow - Loops](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-control-flow-loops)
1. [Control Flow - Scopes](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-control-flow-run-steps-group-scopes)
1. [Using SQL with Logic Apps](../Scenarios-Read-Me/README-Sql-on-prem-Logic-Apps.md)
1. [Sending Email](../Scenarios-Read-Me/README-Send-email.md)

#### Create Logic App using Office 365 Outlook Connector
We'll now create a logic app in the portal to validate that we can send an email based on control flow conditionals.

![Create a Logic App](../Media/Scenario-Conditional-for-each/create-logic-app-1.png 'Create A Logic App')

We'll use a trigger in the logic app.  In this case, we'll just set up recurrence for testing.

![Recurrence Trigger](../Media/Scenario-Conditional-for-each/logic-app-config-step-1.png 'Recurrence Trigger')

We can borrow the concepts to connect to a database, and then add subsequent actions based on working with that step.  For more details on using databases with Logic apps, please refer to the scenario guide.  We can also add a subsequent step to send an email after receiving the results from the database fetch.

1. [Using SQL with Logic Apps](../Scenarios-Read-Me/README-Sql-on-prem-Logic-Apps.md)
1. [Sending Email](../Scenarios-Read-Me/README-Send-email.md)

We can wrap the send email call with a For-Each.  This will be generated if we use the dynamic content from the step of pulling from the database.

![Use Office 365 Web API Outlook Connector.](../Media/Scenario-Conditional-for-each/logic-app-config-step-2.png 'Use Office 365 Outlook Connector')

Let's add the Office 365 Outlook connector as an action. We can begin adding stepss, and also a parallel branch.

![Use Office 365 Web API Outlook Connector.](../Media/Scenario-Conditional-for-each/logic-app-config-step-3.png 'Use Office 365 Outlook Connector')

The logic app connector will let us configure the 'run after setttings'.  This is a way of setting up some of the conditional aspects for the control flow.

![Configure SMTP Connection.](../Media/Scenario-Conditional-for-each/logic-app-config-step-4.png 'Configure SMTP Connection')

For instance, we can set this connector action to run if the prior step has a time out or failure.

![Set up test mail.](../Media/Scenario-Conditional-for-each/logic-app-config-step-5.png 'Set up test mail')

Seeing it all together, we can show that we have a for-each that we can wrap around sending an email upon success, and upon a timeout, sending a notification email that indicates that there was a timeout or failure.

![Configure Email Message](../Media/Scenario-Conditional-for-each/logic-app-config-step-6.png 'Configure Email Message')

Click on Save Button, then run the application, then view the designer.

![Verify Test Email.](../Media/Scenario-Conditional-for-each/logic-app-config-step-7.png 'Set up test mail')

We can check that the email was sent from our outlook client send folder.

![Verify Test Email.](../Media/Scenario-Conditional-for-each/logic-app-config-step-8.png 'Set up test mail')

And also check the test email on the receiver side.

![Verify Test Email.](../Media/Scenario-Conditional-for-each/logic-app-config-step-9.png 'Set up test mail')

We can also stop the database, and then test out the timeout path.

```
docker stop <container id>
```


![Verify Failed Path.](../Media/Scenario-Conditional-for-each/logic-app-config-step-10.png 'Send Fail Email')

We can check our send folder on the sender outlook client and see the send message.

![Verify Failed Path.](../Media/Scenario-Conditional-for-each/logic-app-config-step-11.png 'Send Fail Email')

We can check our folder on the receiver outlook client and see the sent message.

![Verify Failed Path.](../Media/Scenario-Conditional-for-each/logic-app-config-step-12.png 'Send Fail Email')