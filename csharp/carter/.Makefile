build:
	 cd csharp/carter && docker build -f .Dockerfile.default -t csharp.carter.default .&& cd -
	 docker run -p 3000:3000 -td csharp.carter.default
	 sleep 5
	 echo '127.0.0.1' > csharp/carter/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat csharp/carter/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat csharp/carter/ip-default.txt` ENGINE=default LANGUAGE=csharp FRAMEWORK=carter DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=csharp.carter.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
