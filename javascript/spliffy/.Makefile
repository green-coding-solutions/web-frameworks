build:
	 cd javascript/spliffy && docker build -f .Dockerfile.uwebsockets -t javascript.spliffy.uwebsockets .&& cd -
	 docker run -p 3000:3000 -td javascript.spliffy.uwebsockets
	 sleep 5
	 echo '127.0.0.1' > javascript/spliffy/ip-uwebsockets.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/spliffy/ip-uwebsockets.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/spliffy/ip-uwebsockets.txt` ENGINE=uwebsockets LANGUAGE=javascript FRAMEWORK=spliffy DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.spliffy.uwebsockets  | xargs docker rm -f
run-all : build.uwebsockets collect.uwebsockets clean.uwebsockets
