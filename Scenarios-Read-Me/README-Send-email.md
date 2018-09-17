## Send an email

#### Links

These will describe some of the concepts that we're using in this scenario.

1. [Office 365 Web API Connector](https://docs.microsoft.com/en-us/azure/connectors/connectors-create-api-office365-outlook)
1. [SMTP Logic App Connector](https://docs.microsoft.com/en-us/azure/connectors/connectors-create-api-smtp)
1. [Pop and IMAP Settings](https://support.office.com/en-us/article/pop-and-imap-account-settings-cb41d2b8-98cb-4ab2-ad60-218349f37e2e?redirectSourcePath=%252fen-us%252farticle%252fPOP-and-IMAP-settings-for-Outlook-Office-365-for-business-7fc677eb-2491-4cbc-8153-8e7113525f6c&ui=en-US&rs=en-US&ad=US)

#### Create Logic App using Office 365 Outlook Connector
We'll now create a logic app in the portal to validate that we can send an email using the Office 365 SMTP settings.

![Create a Logic App](../Media/Scenario-Send-email/create-logic-app-1.png 'Create A Logic App')

We'll use a trigger in the logic app.  In this case, we'll just set up recurrence for testing.

![Recurrence Trigger](../Media/Scenario-Send-email/logic-app-config-step-1.png 'Recurrence Trigger')

Let's add the Office 365 Outlook connector as an action.  In prior steps, we can have a trigger of some sort.  For now we can use the recurrence.

![Use Office 365 Web API Outlook Connector.](../Media/Scenario-Send-email/logic-app-config-step-2.png 'Use Office 365 Outlook Connector')

Inside the logic app, we can add a connector for Office 365 Outlook.  We'll want to sign in so the logic app can establish a connection:

![Configure SMTP Connection.](../Media/Scenario-Send-email/logic-app-config-step-3.png 'Configure SMTP Connection')

Allow access to Office 365 to the Logic App.

![Set up test mail.](../Media/Scenario-Send-email/logic-app-config-step-4.png 'Set up test mail')

We can configure an email message next.

![Configure Email Message](../Media/Scenario-Send-email/logic-app-config-step-5.png 'Configure Email Message')

Click on Save Button, then run the application, then view the designer.

![Verify Test Email.](../Media/Scenario-Send-email/logic-app-config-step-6.png 'Set up test mail')

We can check that the email was sent from our outlook client send folder.

![Verify Test Email.](../Media/Scenario-Send-email/logic-app-config-step-7.png 'Set up test mail')

And also check the test email on the receiver side.

![Verify Test Email.](../Media/Scenario-Send-email/logic-app-config-step-8.png 'Set up test mail')

#### SMTP Connector

From the docs: https://docs.microsoft.com/en-us/azure/connectors/connectors-create-api-smtp

   | Property | Required | Description |
   |----------|----------|-------------|
   | **Connection Name** | Yes | A name for the connection to your SMTP server | 
   | **SMTP Server Address** | Yes | The address for your SMTP server | 
   | **User Name** | Yes | Your username for your SMTP account | 
   | **Password** | Yes | Your password for your SMTP account | 
   | **SMTP Server Port** | No | A specific port on your SMTP server you want to use | 
   | **Enable SSL?** | No | Turn on or turn off SSL encryption. | 
   |||| 

