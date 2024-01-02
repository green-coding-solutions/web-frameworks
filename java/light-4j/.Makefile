build:
	 cd java/light-4j && docker build -f .Dockerfile.default -t java.light-4j.default .&& cd -
	 docker run -p 3000:3000 -td java.light-4j.default
	 sleep 5
	 echo '127.0.0.1' > java/light-4j/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat java/light-4j/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat java/light-4j/ip-default.txt` ENGINE=default LANGUAGE=java FRAMEWORK=light-4j DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=java.light-4j.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
