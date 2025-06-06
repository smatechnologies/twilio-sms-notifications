# Twilio SMS Notification Script for SMA OpCon
This repository contains a powershell script and procedures for implementing Twilio for your SMS notifications within SMA OpCon. Please refer to the procedures below for information on how to set up and configure this functionality.
 

# Disclaimer
No Support and No Warranty are provided by SMA Technologies for this project and related material. The use of this project's files is on your own risk.

SMA Technologies assumes no liability for damage caused by the usage of any of the files offered here via this Github repository.
​
By downloading and using this solution from Unisoft International, Inc., dba SMA Technologies, you acknowledge that it requires a Twilio account, which you must create, own, pay for, and manage in accordance with Twilio’s terms and conditions. This solution enables SMS messaging, including to employees or users, and you are solely responsible for obtaining proper consent, honoring opt-out requests, and complying with all applicable laws and regulations. SMA Technologies disclaims all liability for misuse, negligent or unauthorized use, regulatory violations, or data privacy breaches. You agree to indemnify and hold harmless SMA Technologies from any third-party claims, penalties, or damages arising from your use. 

# Prerequisites

The first step to implementing Twilio SMS notifications in OpCon is to create a Twilio account and get a Twilio phone number. When you do this, you need to make sure that the phone number you get has the ability to send out SMS messages. This may require you to register your account/company with the A2P 10DLC registration. It is the responsibility of the client to make sure that all federal regulations in regard to Application to Person (A2P) SMS messaging are met.

Once you have created your Twilio account and phone number, you will need the following information:

Twilio Account SID

Twilio Auth Token

Twilio Phone Number Twilio API URL for SMS Messages (the current URL is `https://api.twilio.com/2010-04-01/Accounts/<Your Twilio Account SID>/Messages.json`, however this may have changed since the writing of this documentation)


# Instructions

Once you have the above information, go into OpCon and do the following:

1. Create Global Properties for the below information:

a. Twilio Account SID

b. Twilio Auth Token (we recommend encrypting this Global Property)

c. Twilio Phone Number

d. Twilio API URL

e. Phone numbers that will receive SMS notifications (if you have multiple, then please put them in the property in a comma delimited list)

2. Download the TwilioSMS.ps1 Powershell script from files.smatechnologies.com.

3. Once you have downloaded the Twilio SMS Notifications Powershell script, you will need to load it into OpCon as a Script/Embedded script. Create a new script/embedded script in OpCon, and load the Powershell file, setting the Script Type to Powershell.

a. This script takes 6 parameters, that you will pass through when you create the job. The 6 parameters are:

i. Twilio Account SID – Use global property created in Step 1

ii. Twilio Auth Token – Use global property created in Step 1

iii. Twilio Phone Number – Use global property created in Step 1

iv. To Phone Numbers – Use global property created in Step 1

v. SMS Message Body – Will be passed to the job as a Job Instance Property

vi. Twilio URL – Use global property created in Step 1

4. Create Schedule for Notifications.

a. You can name this schedule according to your naming conventions, but make sure it’s something intuitive that will help you recognize its purpose

b. You don’t necessarily need to create a new schedule, especially if you already have a schedule that you use for notifications. If you do, then skip to Step 6.

5. Create a Null job in the new schedule

a. This is to keep the schedule built out and available to receive the notification jobs.

b. Give this Null job a frequency that will cause it to be built out every day. Have it run at 12:00 AM

6. Create a new Embedded Script job

a. This can be in the new schedule you created, or in an existing schedule.

b. Name this job according to your naming conventions, preferably something that will help you recognize its purpose.

c. Check the Allow Multi Instance checkbox.

d. Set this job to run on a Windows agent in your environment. Please make sure the machine that this agent runs on has access to the Twilio URL through the internet.

e. Set the job sub type as Embedded script

f. Select the new script/embedded script that you created in Step 3.

i. Set the Version to Latest

g. Select Powershell as the Runner.

h. For the Arguments, enter the following string, substituting the names of the global properties created in Step 1:

i. -TwilioAccountSid [[TwilioSID]] -TwilioAuthToken [[TwilioAuthToken]] -TwilioFromNumber [[TwilioFromNumber]] -toNumber “[[SMSAlertsToNumbers]]” -SMSMessageBody "[[JI.SMSMessage]]" -TwilioURL "[[TwilioURL]]"

ii. Make sure that the properties for the -toNumber, -SMSMessageBody, and -TwilioURL are in quotes (“), as there can be spaces in these parameter values that can keep the script from running.

iii. The script will trim the -SMSMessageBody value down to 160 characters, so if you have SMS Messages longer than 160 characters they will be cut off at 160 characters.

i. Add proper documentation to the Documentation Tab

j. Add any necessary Tags that your environment requires.

k. For the Frequency, please set this to OnRequest, and set a start time of 12:00 AM to ensure that the job will start immediately once added to the schedule. Add any other frequency settings that you see fit.

l. Add any other job settings that you see fit.

m. Save the job.

7. Create the Notification

a. Solution Manager

i. Login to Solution Manager.

ii. Navigate to Library -> Notification Triggers.

iii. Click on Manage Groups in the upper right corner.

iv. Click on the green +Add button in the top left.

v. Choose a name for your Notification Group, preferably something intuitive ie SMS Notifications.

vi. Under Type, select Job.

vii. Select which jobs you wish this Notification Group to apply to.

viii. Click Save in the lower left.

ix. Click on Notification Triggers in the upper right.

x. Click on the green +Add button in the upper left

xi. Select the Notification Group that you just created.

xii. Select the trigger you wish this notification to be triggered by.

xiii. Click the green + button the OpCon Events button

xiv. Create the OpCon event to add the job created in Step 6 above.

1. Use the $JOB:ADD event, and fill in the necessary information in the parameters.

2. Make sure you add an instance property for the job named SMSMessage. Put in this message whatever you want to the text to say. Keep in mind, the powershell script will trim the message down to the 160 limit of an SMS message.

3. Click Ok

xv. Click Save in the lower left.

xvi. Test the event to verify that it works.


b. Enterprise Manager

i. Login to Enterprise Manager

ii. Open up Notification Manager

iii. Click on the Jobs tab

iv. Right click on the white space under Notification Triggers and select Create Root Group

v. Name the root group something intuitive, ie SMS Notifications

vi. Select the new root group that you just created. This will show the OpCon schedules on the right portion of the screen. Select the schedules and jobs that you wish to add SMS Notifications for.

vii. Right click on the new root group that you just created and hover your mouse over Add Job Trigger. Click on the Job Trigger that you wish to trigger the sending of SMS Notifications.

viii. Click on the Job Trigger that was just added under your group.

1. Check the Send OpCon/xps Events check box under the General tab.

2. Click on the Event tab

3. Click the +Add button

4. Create the OpCon event to add the job you created in Step 6 above

a. Use the $JOB:ADD event, and fill in the necessary information in the parameters.

b. Make sure you add an instance property for the job named SMSMessage. Put in this message whatever you want to the text to say. Keep in mind, the powershell script will trim the message down to the 160 limit of an SMS message.

5. Click Finish

6. Test the event to verify that it works.


# License
Copyright 2019 SMA Technologies

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

# Contributing
We love contributions, please read our [Contribution Guide](CONTRIBUTING.md) to get started!

# Code of Conduct
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](code-of-conduct.md)
SMA Technologies has adopted the [Contributor Covenant](CODE_OF_CONDUCT.md) as its Code of Conduct, and we expect project participants to adhere to it. Please read the [full text](CODE_OF_CONDUCT.md) so that you can understand what actions will and will not be tolerated.
