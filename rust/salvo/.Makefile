build:
	 cd rust/salvo && docker build -f .Dockerfile.default -t rust.salvo.default .&& cd -
	 docker run -p 3000:3000 -td rust.salvo.default
	 sleep 5
	 echo '127.0.0.1' > rust/salvo/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat rust/salvo/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat rust/salvo/ip-default.txt` ENGINE=default LANGUAGE=rust FRAMEWORK=salvo DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=rust.salvo.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
