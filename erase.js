var thinky, opts, db, r, thing;
thinky = require('thinky')
opts = {
  db : "todo_app_LOCAL",
  host : "",
  port : "",
  authKey : "uRf77UnjvzhuoAI0t4ZMnvmFG6609XQKbCkFJNe8GQ"
}
db = thinky(opts)
r = db.r
thing = function(){
  r.table('User').delete().run().then(function(){
    console.log("Delete Happen")
  })
}
thing()
