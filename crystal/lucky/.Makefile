build:
	 cd crystal/lucky && docker build -f .Dockerfile.default -t crystal.lucky.default .&& cd -
	 docker run -p 3000:3000 -td crystal.lucky.default
	 sleep 5
	 echo '127.0.0.1' > crystal/lucky/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat crystal/lucky/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat crystal/lucky/ip-default.txt` ENGINE=default LANGUAGE=crystal FRAMEWORK=lucky DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=crystal.lucky.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
