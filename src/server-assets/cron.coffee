{CronJob} = require 'cron'

{db} = require "#{__dirname}/src/server-assets/config/dbConfig"
console.log db
{r} = db

new CronJob '15 12 15 * * *', () ->
  console.log "PEWWWWWWW"
, null, true, 'America/Chicago'
