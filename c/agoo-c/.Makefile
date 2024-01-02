build:
	 cd c/agoo-c && docker build -f .Dockerfile.default -t c.agoo-c.default .&& cd -
	 docker run -p 3000:3000 -td c.agoo-c.default
	 sleep 5
	 echo '127.0.0.1' > c/agoo-c/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat c/agoo-c/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat c/agoo-c/ip-default.txt` ENGINE=default LANGUAGE=c FRAMEWORK=agoo-c DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=c.agoo-c.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
