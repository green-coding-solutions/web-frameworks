build:
	 cd java/quarkus && docker build -f .Dockerfile.default -t java.quarkus.default .&& cd -
	 docker run -p 3000:3000 -td java.quarkus.default
	 sleep 5
	 echo '127.0.0.1' > java/quarkus/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat java/quarkus/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat java/quarkus/ip-default.txt` ENGINE=default LANGUAGE=java FRAMEWORK=quarkus DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=java.quarkus.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
