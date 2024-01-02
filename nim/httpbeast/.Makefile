build:
	 cd nim/httpbeast && docker build -f .Dockerfile.default -t nim.httpbeast.default .&& cd -
	 docker run -p 3000:3000 -td nim.httpbeast.default
	 sleep 5
	 echo '127.0.0.1' > nim/httpbeast/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat nim/httpbeast/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat nim/httpbeast/ip-default.txt` ENGINE=default LANGUAGE=nim FRAMEWORK=httpbeast DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=nim.httpbeast.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
