#We use NPM child_process to use radtest on the terminal(DO NOT RUN AS ROOT)
exec = Npm.require('child_process').exec

Meteor.methods
  loginWithRadius: (user, user_password) ->
    #Check the passed arguments - they should be Strings
    check user, String
    check user_password, String
    #Run the whole logic in the callback of the exec() call
    #To keep the AccountCreation in a Fiber we use Meteor.bindEnvironment()
    runCommand = Meteor.bindEnvironment((error, stdout, stderr) ->
      #The console output for the request evaluates to a failure
      if stdout.indexOf('Access-Accept') == -1
        #Log the failed login request
        console.log 'failed login attempt', user
      else
        #The console output for the request evaluates to a success
        if stdout.indexOf('Access-Accept') > -1
          #Log the successful login request
          console.log 'successful login attempt', user
          #You can change the mail suffix to fit your needs
          userEmail = user + '@whu.edu'
          #Check if the User has an account already
          if Meteor.users.find({'emails.0.address': userEmail}).count() > 0
            #If yes stop the request here - the job is done
            return true
          else
            #Create a very basic new user based on the passed credentials
            Accounts.createUser
              username: user,
              email : userEmail,
              password : user_password
            #When done stop the request here - the job is done
            return true
      #If there are any errors during execution of the radtest print them
      if error != null
        console.log 'exec error: ' + error
      #We are through - the job should be done
      return
    )
    #We use the radtest utility to get a radius result
    query = "radtest"
    query += " "
    #In my usecase I used PAP as the type option
    #You can also use:
    # - CHAP
    # - MSCHAP
    # - EAP-MD5
    query += "-t pap"
    query += " "
    #Pass the user as the first argument
    query += user
    query += " "
    #Pass the password as the second argument
    query += user_password
    query += " "
    #Pass the RADIUSIP as the third argument
    query += process.env.RADIUSIP
    query += " "
    #Pass the RADIUSPORT as the fourth argument
    query += process.env.RADIUSPORT
    query += " "
    #Pass the RADIUSSECRET as the fifth argument
    query += process.env.RADIUSSECRET
    #Set the env vars with an export or on execution of the meteor app
    #You find further information on the implementation here:
    #http://freeradius.org/radiusd/man/radtest.html

    #Run the whole thing
    exec(query, runCommand);

    #Give a data feedback
    return
