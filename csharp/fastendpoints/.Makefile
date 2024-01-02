build:
	 cd csharp/fastendpoints && docker build -f .Dockerfile.default -t csharp.fastendpoints.default .&& cd -
	 docker run -p 3000:3000 -td csharp.fastendpoints.default
	 sleep 5
	 echo '127.0.0.1' > csharp/fastendpoints/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat csharp/fastendpoints/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat csharp/fastendpoints/ip-default.txt` ENGINE=default LANGUAGE=csharp FRAMEWORK=fastendpoints DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=csharp.fastendpoints.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
