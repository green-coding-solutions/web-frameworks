build:
	 cd swift/vapor-framework && docker build -f .Dockerfile.default -t swift.vapor-framework.default .&& cd -
	 docker run -p 3000:3000 -td swift.vapor-framework.default
	 sleep 5
	 echo '127.0.0.1' > swift/vapor-framework/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat swift/vapor-framework/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat swift/vapor-framework/ip-default.txt` ENGINE=default LANGUAGE=swift FRAMEWORK=vapor-framework DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=swift.vapor-framework.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
