build:
	 cd csharp/aspnet-mvc && docker build -f .Dockerfile.default -t csharp.aspnet-mvc.default .&& cd -
	 docker run -p 3000:3000 -td csharp.aspnet-mvc.default
	 sleep 5
	 echo '127.0.0.1' > csharp/aspnet-mvc/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat csharp/aspnet-mvc/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat csharp/aspnet-mvc/ip-default.txt` ENGINE=default LANGUAGE=csharp FRAMEWORK=aspnet-mvc DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=csharp.aspnet-mvc.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
