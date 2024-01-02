build:
	 cd nim/rosencrantz && docker build -f .Dockerfile.default -t nim.rosencrantz.default .&& cd -
	 docker run -p 3000:3000 -td nim.rosencrantz.default
	 sleep 5
	 echo '127.0.0.1' > nim/rosencrantz/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat nim/rosencrantz/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat nim/rosencrantz/ip-default.txt` ENGINE=default LANGUAGE=nim FRAMEWORK=rosencrantz DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=nim.rosencrantz.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
