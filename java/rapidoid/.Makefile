build:
	 cd java/rapidoid && docker build -f .Dockerfile.default -t java.rapidoid.default .&& cd -
	 docker run -p 3000:3000 -td java.rapidoid.default
	 sleep 5
	 echo '127.0.0.1' > java/rapidoid/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat java/rapidoid/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat java/rapidoid/ip-default.txt` ENGINE=default LANGUAGE=java FRAMEWORK=rapidoid DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=java.rapidoid.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
