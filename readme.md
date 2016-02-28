### Making changes to the repo ###
Create your own fork and fool around with the api. You can create pull requests on/ push to the Slant Six dev branch and Heroku will deploy the updates to:  
https://thinky-practice-dev.herokuapp.com/

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
