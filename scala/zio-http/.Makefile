build:
	 cd scala/zio-http && docker build -f .Dockerfile.default -t scala.zio-http.default .&& cd -
	 docker run -p 3000:3000 -td scala.zio-http.default
	 sleep 5
	 echo '127.0.0.1' > scala/zio-http/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat scala/zio-http/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat scala/zio-http/ip-default.txt` ENGINE=default LANGUAGE=scala FRAMEWORK=zio-http DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=scala.zio-http.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
