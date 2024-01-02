build:
	 cd java/act && docker build -f .Dockerfile.default -t java.act.default .&& cd -
	 docker run -p 3000:3000 -td java.act.default
	 sleep 5
	 echo '127.0.0.1' > java/act/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat java/act/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat java/act/ip-default.txt` ENGINE=default LANGUAGE=java FRAMEWORK=act DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=java.act.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
