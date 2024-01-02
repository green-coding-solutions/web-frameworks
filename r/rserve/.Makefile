build:
	 cd r/rserve && docker build -f .Dockerfile.default -t r.rserve.default .&& cd -
	 docker run -p 3000:3000 -td r.rserve.default
	 sleep 5
	 echo '127.0.0.1' > r/rserve/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat r/rserve/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat r/rserve/ip-default.txt` ENGINE=default LANGUAGE=r FRAMEWORK=rserve DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=r.rserve.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
