(function() {
  module.exports = {
    logger: function(req, res, next) {
      console.log(req.method + " request to >>>> " + req.originalUrl);
      if (req.body === !{}) {
        console.log('REQUEST BODY >>>>', req.body);
      }
      if (req.params === !{}) {
        console.log('REQUEST PARAMETERS >>>>', req.params);
      }
      return next();
    },
    port: process.env.PORT || 9999
  };

}).call(this);
