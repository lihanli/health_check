health_check
============

Sends an http request every x minutes to a list of websites. (default is 15 minutes)  
If a request doesn't go through or if the response code isn't 2xx or 3xx then it will send you an email.  
Installs as an upstart background service.

#### Requirements

* rbenv with ruby >= 1.9.2 installed
* linux with upstart installed (installed by default on ubuntu)
* gmail account to send emails

#### Installation

```
$ git clone git@github.com:lihanli/health_check.git
$ cd health_check
```

Add sites.rb file  

```ruby
SITES = [
  'http://google.com',
  'http://yahoo.com:80'
]
```
Add gmail_credentials.rb file

```ruby
GMAIL = {
  username: 'foo@gmail.com',
  password: 'your_password',
  notifications_addr: 'who_to_send_emails_to@email.com'
}
```

Gmail blocks by default cloud server IPs.  
https://accounts.google.com/b/0/DisplayUnlockCaptcha  
Go to the above link, follow the instructions, then try to send an email with the gmail
credentials you want to use from the box you are using to run this service. Make sure
the email goes through.


Install and start the service
```
$ ./install
```

#### Other
Run the view_log script to see the program's log

Run this command to see if the service is running
```
sudo status health_check
```

