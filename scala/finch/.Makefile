build:
	 cd scala/finch && docker build -f .Dockerfile.default -t scala.finch.default .&& cd -
	 docker run -p 3000:3000 -td scala.finch.default
	 sleep 5
	 echo '127.0.0.1' > scala/finch/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat scala/finch/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat scala/finch/ip-default.txt` ENGINE=default LANGUAGE=scala FRAMEWORK=finch DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=scala.finch.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
