# README

This is a simple application where your Stripe account is integrated through Stripe CLI and events happening in your stripe account triggers data manipulation in your application DB.

There are 3 events that is covered in this application:

* When a subscription is created, a record of subscription is created in the application DB
* The initial state of the subscription record in the application DB is be 'unpaid'
* Paying the first invoice of the subscription changes the state of your local subscription record from 'unpaid' to 'paid'
* Canceling a subscription changes the state of your subscription record to “canceled”
* Only subscriptions in the state “paid” can be canceled

All the these state changes can be viewed through the 
* Logs of the application
* Application DB
* If you run "stripe listen" command, live logging can also be viewed

The endpoint is created using ngrok since it is running on a local machine.

How to run the application ?

run `rails s -p 4242`

run `ngrok http http://localhost:4242`

run `stripe listen`
