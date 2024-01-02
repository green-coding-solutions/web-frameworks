build:
	 cd c/kore && docker build -f .Dockerfile.default -t c.kore.default .&& cd -
	 docker run -p 3000:3000 -td c.kore.default
	 sleep 5
	 echo '127.0.0.1' > c/kore/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat c/kore/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat c/kore/ip-default.txt` ENGINE=default LANGUAGE=c FRAMEWORK=kore DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=c.kore.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
