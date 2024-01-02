build:
	 cd swift/kitura && docker build -f .Dockerfile.default -t swift.kitura.default .&& cd -
	 docker run -p 3000:3000 -td swift.kitura.default
	 sleep 5
	 echo '127.0.0.1' > swift/kitura/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat swift/kitura/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat swift/kitura/ip-default.txt` ENGINE=default LANGUAGE=swift FRAMEWORK=kitura DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=swift.kitura.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
