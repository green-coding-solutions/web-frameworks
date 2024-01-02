build:
	 cd csharp/aspnet-minimal-api && docker build -f .Dockerfile.default -t csharp.aspnet-minimal-api.default .&& cd -
	 docker run -p 3000:3000 -td csharp.aspnet-minimal-api.default
	 sleep 5
	 echo '127.0.0.1' > csharp/aspnet-minimal-api/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat csharp/aspnet-minimal-api/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat csharp/aspnet-minimal-api/ip-default.txt` ENGINE=default LANGUAGE=csharp FRAMEWORK=aspnet-minimal-api DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=csharp.aspnet-minimal-api.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
