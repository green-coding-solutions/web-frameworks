build:
	 cd nim/happyx && docker build -f .Dockerfile.default -t nim.happyx.default .&& cd -
	 docker run -p 3000:3000 -td nim.happyx.default
	 sleep 5
	 echo '127.0.0.1' > nim/happyx/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat nim/happyx/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat nim/happyx/ip-default.txt` ENGINE=default LANGUAGE=nim FRAMEWORK=happyx DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=nim.happyx.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
