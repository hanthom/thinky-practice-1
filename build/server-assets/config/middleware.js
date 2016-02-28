(function() {
  var bodyParser, logger;

  bodyParser = require('body-parser');

  logger = require(__dirname + "/serverConfig").logger;

  module.exports = function(app) {
    app.use(bodyParser.json());
    return app.use(logger);
  };

}).call(this);
