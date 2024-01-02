build:
	 cd dart/shelf && docker build -f .Dockerfile.default -t dart.shelf.default .&& cd -
	 docker run -p 3000:3000 -td dart.shelf.default
	 sleep 5
	 echo '127.0.0.1' > dart/shelf/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat dart/shelf/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat dart/shelf/ip-default.txt` ENGINE=default LANGUAGE=dart FRAMEWORK=shelf DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=dart.shelf.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
