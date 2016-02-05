postinstall: gulp build
web: nohup ssh -n -i compose-heroku-key -o StrictHostKeyChecking=no \
-N compose@aws-us-east-1-portal.7.dblayer.com -p 10585 \
-L 127.0.0.1:28015:10.84.48.2:28015 \
-L 127.0.0.1:8082:10.84.48.2:8080 && npm start'
