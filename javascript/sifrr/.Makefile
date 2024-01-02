build:
	 cd javascript/sifrr && docker build -f .Dockerfile.uwebsockets -t javascript.sifrr.uwebsockets .&& cd -
	 docker run -p 3000:3000 -td javascript.sifrr.uwebsockets
	 sleep 5
	 echo '127.0.0.1' > javascript/sifrr/ip-uwebsockets.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/sifrr/ip-uwebsockets.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/sifrr/ip-uwebsockets.txt` ENGINE=uwebsockets LANGUAGE=javascript FRAMEWORK=sifrr DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.sifrr.uwebsockets  | xargs docker rm -f
run-all : build.uwebsockets collect.uwebsockets clean.uwebsockets
