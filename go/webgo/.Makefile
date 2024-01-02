build:
	 cd go/webgo && docker build -f .Dockerfile.net-http -t go.webgo.net-http .&& cd -
	 docker run -p 3000:3000 -td go.webgo.net-http
	 sleep 5
	 echo '127.0.0.1' > go/webgo/ip-net-http.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat go/webgo/ip-net-http.txt`:3000 -v
collect:
	 HOSTNAME=`cat go/webgo/ip-net-http.txt` ENGINE=net-http LANGUAGE=go FRAMEWORK=webgo DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=go.webgo.net-http  | xargs docker rm -f
run-all : build.net-http collect.net-http clean.net-http
