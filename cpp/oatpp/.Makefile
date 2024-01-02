build:
	 cd cpp/oatpp && docker build -f .Dockerfile.default -t cpp.oatpp.default .&& cd -
	 docker run -p 3000:3000 -td cpp.oatpp.default
	 sleep 5
	 echo '127.0.0.1' > cpp/oatpp/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat cpp/oatpp/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat cpp/oatpp/ip-default.txt` ENGINE=default LANGUAGE=cpp FRAMEWORK=oatpp DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=cpp.oatpp.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
