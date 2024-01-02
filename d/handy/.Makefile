build:
	 cd d/handy && docker build -f .Dockerfile.default -t d.handy.default .&& cd -
	 docker run -p 3000:3000 -td d.handy.default
	 sleep 5
	 echo '127.0.0.1' > d/handy/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat d/handy/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat d/handy/ip-default.txt` ENGINE=default LANGUAGE=d FRAMEWORK=handy DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=d.handy.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
