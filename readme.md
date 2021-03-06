# Getting Started

## RethinkDB

For this repo I'm using [RethinkDB](https://www.rethinkdb.com/) with the [thinky](https://thinky.io/) ORM.

I assume you've got [homebrew](http://brew.sh/). I also assume you're using a OS X system. If not, checkout the [instructions](https://www.rethinkdb.com/docs/install/) for installing to your OS. Don't worry about getting the client driver, that will be installed with npm.

Run `brew install rethinkdb`. In your home folder run `rethinkdb`. This will spin up a rethinkdb server on your machine. After it starts you can access the admin GUI at [localhost:8080/](http://localhost:8080/).

### With the tunnel.py script running

Use `gulp tunnel` to start the tunnel with the task. It will only work if you've got the .env.json file for the repo or you've manually set the env variables yourself. If you want to just run tunnel.py you can open a terminal window and run `python tunnel.py`. If you're interested check the ssh connections on your machine using `lsof -i -n | egrep '\<ssh\>'`. You can kill all ssh tunnels using `killall ssh`. The script will try to map the hosted rethinkdb server ports (8080 and 28015) to the local ports so make sure these are freed up before trying to start the tunnel.

### To check the gui without ssh connection

You'll need to set up a login for an ssl connection to the DB. After that you can access it at [aws-us-east-1-portal7.dblayer.com:10583](https://aws-us-east-1-portal7.dblayer.com:10583/)

### Commands in the Data Explorer

The gui that RethinkDB provides for [data exploration and manipulation](https://www.rethinkdb.com/docs/reql-data-exploration/) is awesome. You can easily practice and refine queries with a little help from the popovers on the cursor.

![Data Explorer](/config/images/data-explorer.png)

# Spinning up your environment

Once you fork and clone the repo and run `npm install`. Once everything is downloaded you should be able to run `gulp`. Study the [tasks.coffee](config/tasks.coffee) file to understand what tasks are doing.To quit use `ctrl + c` in the terminal twice (once for nodemon and once for the watch task). We're using [inquirer.js](https://github.com/SBoudrias/Inquirer.js/) to handle setup through gulp. Use the space bar and arrow keys to select inputs and hit enter to submit your selections.

![Inquirer Setup](/config/images/inquirer-setup.png)

# Making changes to the repo

Check out [this](https://guides.github.com/introduction/flow/index.html) guide on the git flow I use. Use your own fork to get familiar with the code in a local environment. Once you're ready to make changes you can create pull requests on/ push to the dev branch first and Heroku will deploy the updates to: [ph-todo-app-dev.herokuapp.com/](https://ph-todo-app-dev.herokuapp.com/). Pull requests to master will generate [review apps](https://devcenter.heroku.com/articles/github-integration-review-apps). If you're in the on the Pink Hippos slack team you'll see updates in the thinky-practice channel.

# Useful Tips

## Work Flow

I use [iTerm](https://www.iterm2.com/) with [Oh My ZSH](http://ohmyz.sh/). The aliases, customization, and theme in zsh are pretty slick. I added `alias tunnels="lsof -i tcp | grep ^ssh"` so I can see all ssh tunnels open on my machine. If you're on the latest OSX you can split your screen using [panels](http://osxdaily.com/2015/10/01/use-split-view-mac-os-x/). It keeps my terminal in view during development so I can see updates in my console easily.  ![El Capitan Panels](/config/images/iterm_and_atom.png)

## Snippets in [Atom](https://atom.io/)

Atom [snippets](https://atom.io/docs/latest/using-atom-snippets) are an easy way to customize shortcuts for speedy development. If you add the snippets below you can type the prefix and hit `tab` to start the snippet. Use `tab` to get to each spot preceded by a $.

```
######
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
  'Require':
    'prefix': 'req'
    'body': 'require "#{__dirname}/${1:pathToFile}"'

  'Process Variable':
    'prefix': 'penv'
    'body': 'process.env.${1:ENV_VARIABLE}'

  'Function Creator':
    'prefix': 'fnc'
    'body': """
    ##### ${1:funtionName} #####
    # ${3:Description}
    # @params: ${4:param1} -> $5
    # @params: ${6:param2} -> $7
    # @returns: $8
    ${1:functionName}${2: =}(${4:param1}, ${6:param2})->
      $9
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


  'Comment1':
    'prefix': 'com1'
    'body': """
    ######
    # $1
    ######
    """

  'Comment2':
    'prefix': 'com2'
    'body': '###### $1 ######'

  'Comment Header':
    'prefix' : 'comhead'
    'body' : """
    ################################################################################
    #                                     $1                                       #
    ################################################################################
    """
```
