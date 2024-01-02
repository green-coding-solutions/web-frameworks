build:
	 cd nim/mike && docker build -f .Dockerfile.default -t nim.mike.default .&& cd -
	 docker run -p 3000:3000 -td nim.mike.default
	 sleep 5
	 echo '127.0.0.1' > nim/mike/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat nim/mike/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat nim/mike/ip-default.txt` ENGINE=default LANGUAGE=nim FRAMEWORK=mike DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=nim.mike.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
