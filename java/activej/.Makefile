build:
	 cd java/activej && docker build -f .Dockerfile.default -t java.activej.default .&& cd -
	 docker run -p 3000:3000 -td java.activej.default
	 sleep 5
	 echo '127.0.0.1' > java/activej/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat java/activej/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat java/activej/ip-default.txt` ENGINE=default LANGUAGE=java FRAMEWORK=activej DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=java.activej.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
