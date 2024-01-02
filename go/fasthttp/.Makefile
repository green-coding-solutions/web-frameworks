build:
	 cd go/fasthttp && docker build -f .Dockerfile.fasthttp -t go.fasthttp.fasthttp .&& cd -
	 docker run -p 3000:3000 -td go.fasthttp.fasthttp
	 sleep 5
	 echo '127.0.0.1' > go/fasthttp/ip-fasthttp.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat go/fasthttp/ip-fasthttp.txt`:3000 -v
collect:
	 HOSTNAME=`cat go/fasthttp/ip-fasthttp.txt` ENGINE=fasthttp LANGUAGE=go FRAMEWORK=fasthttp DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=go.fasthttp.fasthttp  | xargs docker rm -f
run-all : build.fasthttp collect.fasthttp clean.fasthttp
