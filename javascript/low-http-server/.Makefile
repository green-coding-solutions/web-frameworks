build:
	 cd javascript/low-http-server && docker build -f .Dockerfile.uwebsockets -t javascript.low-http-server.uwebsockets .&& cd -
	 docker run -p 3000:3000 -td javascript.low-http-server.uwebsockets
	 sleep 5
	 echo '127.0.0.1' > javascript/low-http-server/ip-uwebsockets.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/low-http-server/ip-uwebsockets.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/low-http-server/ip-uwebsockets.txt` ENGINE=uwebsockets LANGUAGE=javascript FRAMEWORK=low-http-server DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.low-http-server.uwebsockets  | xargs docker rm -f
run-all : build.uwebsockets collect.uwebsockets clean.uwebsockets
