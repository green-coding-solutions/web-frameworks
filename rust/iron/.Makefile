build:
	 cd rust/iron && docker build -f .Dockerfile.default -t rust.iron.default .&& cd -
	 docker run -p 3000:3000 -td rust.iron.default
	 sleep 5
	 echo '127.0.0.1' > rust/iron/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat rust/iron/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat rust/iron/ip-default.txt` ENGINE=default LANGUAGE=rust FRAMEWORK=iron DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=rust.iron.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
