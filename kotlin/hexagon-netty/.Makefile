build:
	 cd kotlin/hexagon-netty && docker build -f .Dockerfile.default -t kotlin.hexagon-netty.default .&& cd -
	 docker run -p 3000:3000 -td kotlin.hexagon-netty.default
	 sleep 5
	 echo '127.0.0.1' > kotlin/hexagon-netty/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat kotlin/hexagon-netty/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat kotlin/hexagon-netty/ip-default.txt` ENGINE=default LANGUAGE=kotlin FRAMEWORK=hexagon-netty DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=kotlin.hexagon-netty.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
