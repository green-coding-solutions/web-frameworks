build:
	 cd nim/scorper && docker build -f .Dockerfile.default -t nim.scorper.default .&& cd -
	 docker run -p 3000:3000 -td nim.scorper.default
	 sleep 5
	 echo '127.0.0.1' > nim/scorper/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat nim/scorper/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat nim/scorper/ip-default.txt` ENGINE=default LANGUAGE=nim FRAMEWORK=scorper DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=nim.scorper.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
