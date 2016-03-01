# Getting Started

## RethinkDB

For this repo I'm using [RethinkDB](https://www.rethinkdb.com/) with the [thinky](https://thinky.io/) ORM.

I assume you've got [homebrew](http://brew.sh/). I also assume you're using a OS X system. If not, checkout the [instructions](https://www.rethinkdb.com/docs/install/) for installing to your OS. Don't worry about getting the client driver, that will be installed with npm.

Run `brew install rethinkdb`. In your home folder run `rethinkdb`. This will spin up a rethinkdb server on your machine. After it starts you can access the GUI at [localhost:8080/](http://localhost:8080/).

### With the tunnel.py script running

The gulpfile has a task to run this script. It will only work if you've got the .env.json file for the repo. If you want to just run tunnel.py you can open a terminal window and run `python tunnel.py`. You can check the ssh connections on your machine using `lsof -i -n | egrep '\<ssh\>'`. You can kill all ssh tunnels using `killall ssh`

### To check the gui without ssh connection

You'll need to set up a login for an ssl connection to the DB. After that you can access it at [aws-us-east-1-portal7.dblayer.com:10583](https://aws-us-east-1-portal7.dblayer.com:10583/)

# Spinning up your environment

Once you fork and clone the repo and run `npm install`. Once everything is downloaded you should be able to run `gulp`. Study the config/tasks.coffee to understand what tasks are doing. The console will log out the activity accordingly. To quit use `ctrl + c` in the terminal twice (once for nodemon and once for the watch task).

# Making changes to the repo

Use your own fork to get familiar with the code in a local environment. Once you're ready to make changes you can create pull requests on/ push to the dev branch first and Heroku will deploy the updates to: [chip-thinky-practice-dev.herokuapp.com/](https://ph-todo-app-dev.herokuapp.com/). Pull requests to master will generate [review apps](https://devcenter.heroku.com/articles/github-integration-review-apps). If you're in the on the Pink Hippos slack team you'll see updates in the thinky-practice channel.

# Useful Tips

## Work Flow

I use [iTerm](https://www.iterm2.com/) with [Oh My ZSH](http://ohmyz.sh/). The aliases, customization, and theme in zsh are pretty slick. If you're on the latest OSX you can split your window like this ![El Capitan Panels](./config/iterm_and_atom.png)

## Snippets in [Atom](https://atom.io/)

Atom [snippets](https://atom.io/docs/latest/using-atom-snippets) are an easy way to customize shortcuts for speedy development. If you add the snippets below you can type the prefix ad hit `tab` to start the snippet. Use `tab` to get to each spot preceded by a $.

```
#####
# Markup Snippets
'.source.gfm':
  'Link':
    'prefix': 'ml',
    'body': '[${1:LinkText}](${2:http://})'

  'Image':
    'prefix': 'img'
    'body': '![${1:imageTitle}](${2:pathToImage})'

  'Header 1':
    'prefix': 'h1'
    'body': '# $1'

  'Header 2':
    'prefix': 'h2'
    'body': '## $1'

  'Header 3':
    'prefix': 'h3'
    'body': '### $1'

  'Header 4':
    'prefix': 'h4'
    'body': '#### $1'

  'Header 5':
    'prefix': 'h5'
    'body': '##### $1'


######
# CoffeeScript Snippets
'.source.coffee':

  'Process Variable':
    'prefix': 'penv'
    'body': 'process.env.${1:ENV_VARIABLE}${2: =}'

  'Function Creator':
    'prefix': 'fnc'
    'body': """
    ##### ${1:funtionName} #####
    # ${3:Description}
    # @params: ${4:param1} -> $5
    # @params: ${6:param2} -> $7
    # @returns: $7
    ${1:functionName}${2: =}(${4:param1}, ${6:param2})->
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

  'Function Param':
    'prefix': 'fparam'
    'body': '# @params: $1 -> $2'


  'Comment':
    'prefix': 'com'
    'body': """
    ######
    # $1
    ######
    """
```
