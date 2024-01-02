build:
	 cd d/serverino && docker build -f .Dockerfile.default -t d.serverino.default .&& cd -
	 docker run -p 3000:3000 -td d.serverino.default
	 sleep 5
	 echo '127.0.0.1' > d/serverino/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat d/serverino/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat d/serverino/ip-default.txt` ENGINE=default LANGUAGE=d FRAMEWORK=serverino DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=d.serverino.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
