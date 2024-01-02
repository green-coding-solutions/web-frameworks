build:
	 cd kotlin/hexagon-jetty && docker build -f .Dockerfile.default -t kotlin.hexagon-jetty.default .&& cd -
	 docker run -p 3000:3000 -td kotlin.hexagon-jetty.default
	 sleep 5
	 echo '127.0.0.1' > kotlin/hexagon-jetty/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat kotlin/hexagon-jetty/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat kotlin/hexagon-jetty/ip-default.txt` ENGINE=default LANGUAGE=kotlin FRAMEWORK=hexagon-jetty DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=kotlin.hexagon-jetty.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
