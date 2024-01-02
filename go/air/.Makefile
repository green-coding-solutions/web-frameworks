build:
	 cd go/air && docker build -f .Dockerfile.net-http -t go.air.net-http .&& cd -
	 docker run -p 3000:3000 -td go.air.net-http
	 sleep 5
	 echo '127.0.0.1' > go/air/ip-net-http.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat go/air/ip-net-http.txt`:3000 -v
collect:
	 HOSTNAME=`cat go/air/ip-net-http.txt` ENGINE=net-http LANGUAGE=go FRAMEWORK=air DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=go.air.net-http  | xargs docker rm -f
run-all : build.net-http collect.net-http clean.net-http
