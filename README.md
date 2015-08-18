# MeteorRadiusAuthentication
Contains a small example on how to easily authenticate users against a radius
server. <br/>
This does not involve building the packets and getting results but using the radtest utility to conduct the radius tests.<br/>

####This method will work on a linux based server with radtest
#####To install radtest on a clean linux you can use apt-get install freeradius-utils

##How to use this
This repository contains a .coffee file which implements a serverside method to
use radius authentication in Meteor.<br/>
If you have set the environment variables you can do something like
```
Meteor.call 'loginWithRadius', email, password, (err) ->
      if err
        console.log err.reason
      else
        Meteor.loginWithPassword email+'@whu.edu', password
```
Now you can bind this Method call to a button click(i.e. the login button) and
pass the values to the call by accessing the value of the username/password
inputs.

##Environment variables
```
This Method uses the following environment variables:
RADIUSIP
RADIUSPORT
RADIUSSECRET

You can set them(OS X/Linux) by executing:
export RADIUSIP="192.168.XXX.XXX"
export RADIUSPORT="1812"
export RADIUSSECRET="XXXXXXXXXXXXXXXXXXXXX"
```
