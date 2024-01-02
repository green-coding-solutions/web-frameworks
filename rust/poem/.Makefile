build:
	 cd rust/poem && docker build -f .Dockerfile.default -t rust.poem.default .&& cd -
	 docker run -p 3000:3000 -td rust.poem.default
	 sleep 5
	 echo '127.0.0.1' > rust/poem/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat rust/poem/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat rust/poem/ip-default.txt` ENGINE=default LANGUAGE=rust FRAMEWORK=poem DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=rust.poem.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
