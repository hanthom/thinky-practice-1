var thinky = require('thinky')

var opts = {
  db : "todo_app_LOCAL",
  host : "",
  port : "",
  authKey : "uRf77UnjvzhuoAI0t4ZMnvmFG6609XQKbCkFJNe8GQ"
}
var db = thinky(opts)
var r = db.r
var thing = function(){
  r.table('User').delete().run().then(function(){
    console.log("Delete Happen")
  })
}

thing()
