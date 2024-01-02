build:
	 cd v/vweb && docker build -f .Dockerfile.default -t v.vweb.default .&& cd -
	 docker run -p 3000:3000 -td v.vweb.default
	 sleep 5
	 echo '127.0.0.1' > v/vweb/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat v/vweb/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat v/vweb/ip-default.txt` ENGINE=default LANGUAGE=v FRAMEWORK=vweb DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=v.vweb.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
