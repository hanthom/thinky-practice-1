## Getting Started ##
### RethinkDB ###
For this repo I'm using [RethinkDB]("https://www.rethinkdb.com/") with the [thinky]("https://thinky.io/") ORM.

Run ```brew install rethinkdb```.
Then from your home folder you can run ```rethinkdb```.
This will spin up a rethinkdb server on your machine.
After it starts you can access the GUI at [localhost:8080/](localhost:8080/).

I assume you've got [homebrew](http://brew.sh/).
I also assume you're using a OS X system.
If not, checkout the
[instructions](https://www.rethinkdb.com/docs/install/)
for installing to your OS.
Don't worry about getting the client driver, that will be installed with npm.

Talk to me about getting env variables for running on the hosted db.

### Compiling and spinning up nodemon server ###
Once you fork and clone the repo and run ```npm install```.
Once everything is downloaded you should be able to run ```gulp```.
The console will log out the activity accordingly.
To quit use ```ctrl + c``` in the terminal twice (once for nodemon and once for the watch task).

# Making changes to the repo ##
Use your own fork to get familiar with the code in a local environment.
Once you're ready to make changes you can create pull requests on/ push to the Slant Six dev branch and Heroku will deploy the updates to:
[thinky-practice-dev.herokuapp.com/]("https://thinky-practice-dev.herokuapp.com/")

### Useful Snippets in Atom ###
Atom snippets for formatted comments and function creations  
Add these to your snippets.cson  
Use tab to get to each spot preceded by a $
```
'.source.coffee':
  'Function Creator':
    'prefix': 'fnc'
    'body': """
    ##### ${1:Funtion Name} #####
    # ${2:Description}
    # @params: $3
    # @returns: $4
    ${5:Function Name} ${6:=} (${7:Parameters})->
      $8
    """

  'Function Commentor':
    'prefix': 'fncom'
    'body': """
    ##### ${1:Funtion Name} #####
    # ${2:Description}
    # @params: $3
    # @returns: $4
    """

  'Comment':
    'prefix': 'com'
    'body': """
    ######
    # $1
    """
```
