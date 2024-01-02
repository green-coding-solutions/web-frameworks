build:
	 cd scala/http4s && docker build -f .Dockerfile.default -t scala.http4s.default .&& cd -
	 docker run -p 3000:3000 -td scala.http4s.default
	 sleep 5
	 echo '127.0.0.1' > scala/http4s/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat scala/http4s/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat scala/http4s/ip-default.txt` ENGINE=default LANGUAGE=scala FRAMEWORK=http4s DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=scala.http4s.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
