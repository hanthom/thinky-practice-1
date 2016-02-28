(function() {
  var app, express, port;

  express = require('express');

  port = require(__dirname + "/config/serverConfig").port;

  app = express();

  app.listen(port, function(e) {
    if (e) {
      return console.log("SPIN UP ERROR >>>> " + e.message);
    } else {
      return console.log("SERVER SPUN UP ON PORT " + port);
    }
  });

  require(__dirname + "/config/middleware")(app);

  require(__dirname + "/routes/todo-routes")(app);

}).call(this);
