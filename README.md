forgot-me-password
==================

### Update

Replaced md5 with SHA2 as md5 is broken.

### Summary 

A client side password generator.

### What is it

Its a chrome app to generate unique passwords for each site. Depending upon the domain and a master password a unique password is generated. It doesn't need any server and everything happens on the client side.

### Why?

I want to use a unique password for each website. However, I don't want to use lastpass/1password as I find their interface confusing and overkill, and I don't want my password stored on remote servers.

I use a simple passwording scheme. I have one master password. For each site, I append the first two letters of the domain to master password and use that as the site password. This is sub-optimal as its easy to understand this scheme, if say two of my passwords are leaked.

I want to algorithmically generate the password on the client side, with a chrome app. 

### How does it work?

    password_1 = SHA256(masterpassword+domain)
    password = take_first_8_letters(password_1)

This will generate a per domain password with 8 characters of entropy and it depends only on master password and the domain.

In the UI side, it works like this:

0. You set your master password in the app.
1. You click the Chrome app button to generate a domain specific password. It generates the domain specific password and copies the password to clipboard.
2. You use the password to signup. Next time you want to login, you click the app to get the password.
