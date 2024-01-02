build:
	 cd rust/gotham && docker build -f .Dockerfile.default -t rust.gotham.default .&& cd -
	 docker run -p 3000:3000 -td rust.gotham.default
	 sleep 5
	 echo '127.0.0.1' > rust/gotham/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat rust/gotham/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat rust/gotham/ip-default.txt` ENGINE=default LANGUAGE=rust FRAMEWORK=gotham DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=rust.gotham.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
