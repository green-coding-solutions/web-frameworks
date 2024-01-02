build:
	 cd go/chi && docker build -f .Dockerfile.net-http -t go.chi.net-http .&& cd -
	 docker run -p 3000:3000 -td go.chi.net-http
	 sleep 5
	 echo '127.0.0.1' > go/chi/ip-net-http.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat go/chi/ip-net-http.txt`:3000 -v
collect:
	 HOSTNAME=`cat go/chi/ip-net-http.txt` ENGINE=net-http LANGUAGE=go FRAMEWORK=chi DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=go.chi.net-http  | xargs docker rm -f
run-all : build.net-http collect.net-http clean.net-http
