build:
	 cd nim/jester && docker build -f .Dockerfile.default -t nim.jester.default .&& cd -
	 docker run -p 3000:3000 -td nim.jester.default
	 sleep 5
	 echo '127.0.0.1' > nim/jester/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat nim/jester/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat nim/jester/ip-default.txt` ENGINE=default LANGUAGE=nim FRAMEWORK=jester DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=nim.jester.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
