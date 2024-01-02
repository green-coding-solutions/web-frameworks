build:
	 cd go/router && docker build -f .Dockerfile.fasthttp -t go.router.fasthttp .&& cd -
	 docker run -p 3000:3000 -td go.router.fasthttp
	 sleep 5
	 echo '127.0.0.1' > go/router/ip-fasthttp.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat go/router/ip-fasthttp.txt`:3000 -v
collect:
	 HOSTNAME=`cat go/router/ip-fasthttp.txt` ENGINE=fasthttp LANGUAGE=go FRAMEWORK=router DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=go.router.fasthttp  | xargs docker rm -f
run-all : build.fasthttp collect.fasthttp clean.fasthttp
