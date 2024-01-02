build:
	 cd java/vertx4web && docker build -f .Dockerfile.default -t java.vertx4web.default .&& cd -
	 docker run -p 3000:3000 -td java.vertx4web.default
	 sleep 5
	 echo '127.0.0.1' > java/vertx4web/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat java/vertx4web/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat java/vertx4web/ip-default.txt` ENGINE=default LANGUAGE=java FRAMEWORK=vertx4web DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=java.vertx4web.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
