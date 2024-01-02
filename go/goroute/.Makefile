build:
	 cd go/goroute && docker build -f .Dockerfile.net-http -t go.goroute.net-http .&& cd -
	 docker run -p 3000:3000 -td go.goroute.net-http
	 sleep 5
	 echo '127.0.0.1' > go/goroute/ip-net-http.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat go/goroute/ip-net-http.txt`:3000 -v
collect:
	 HOSTNAME=`cat go/goroute/ip-net-http.txt` ENGINE=net-http LANGUAGE=go FRAMEWORK=goroute DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=go.goroute.net-http  | xargs docker rm -f
run-all : build.net-http collect.net-http clean.net-http
