build:
	 cd cpp/drogon && docker build -f .Dockerfile.default -t cpp.drogon.default .&& cd -
	 docker run -p 3000:3000 -td cpp.drogon.default
	 sleep 5
	 echo '127.0.0.1' > cpp/drogon/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat cpp/drogon/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat cpp/drogon/ip-default.txt` ENGINE=default LANGUAGE=cpp FRAMEWORK=drogon DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=cpp.drogon.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
