Atom snippets for formatted comments and function creations.

Add these to your snippets.cson
```
'.source.coffee':
  'Function Creator':
    'prefix': 'fnc'
    'body': """
    #---------#
    # ${1:Funtion Name}
    # ${2:Description}
    # @params: $3
    # @returns: $4
    ${5:Function Name} ${6:=} (${7:Parameters})->
      $8
    """

  'Function Commentor':
    'prefix': 'fncom'
    'body': """
      #---------#
      # ${1:Funtion Name}
      # ${2:Description}
      # @params: $3
      # @returns: $4
    """

  'Comment':
    'prefix': 'com'
    'body': """
    #---------#
    # $1
    """
```
