build:
	 cd d/cgi && docker build -f .Dockerfile.default -t d.cgi.default .&& cd -
	 docker run -p 3000:3000 -td d.cgi.default
	 sleep 5
	 echo '127.0.0.1' > d/cgi/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat d/cgi/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat d/cgi/ip-default.txt` ENGINE=default LANGUAGE=d FRAMEWORK=cgi DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=d.cgi.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
