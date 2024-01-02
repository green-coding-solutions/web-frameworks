build:
	 cd csharp/simplify.web && docker build -f .Dockerfile.default -t csharp.simplify.web.default .&& cd -
	 docker run -p 3000:3000 -td csharp.simplify.web.default
	 sleep 5
	 echo '127.0.0.1' > csharp/simplify.web/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat csharp/simplify.web/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat csharp/simplify.web/ip-default.txt` ENGINE=default LANGUAGE=csharp FRAMEWORK=simplify.web DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=csharp.simplify.web.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
