build:
	 cd nim/whip && docker build -f .Dockerfile.default -t nim.whip.default .&& cd -
	 docker run -p 3000:3000 -td nim.whip.default
	 sleep 5
	 echo '127.0.0.1' > nim/whip/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat nim/whip/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat nim/whip/ip-default.txt` ENGINE=default LANGUAGE=nim FRAMEWORK=whip DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=nim.whip.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
