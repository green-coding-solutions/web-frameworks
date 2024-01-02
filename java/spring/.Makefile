build:
	 cd java/spring && docker build -f .Dockerfile.default -t java.spring.default .&& cd -
	 docker run -p 3000:3000 -td java.spring.default
	 sleep 5
	 echo '127.0.0.1' > java/spring/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat java/spring/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat java/spring/ip-default.txt` ENGINE=default LANGUAGE=java FRAMEWORK=spring DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=java.spring.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
