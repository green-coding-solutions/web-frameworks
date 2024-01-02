build:
	 cd nim/prologue && docker build -f .Dockerfile.default -t nim.prologue.default .&& cd -
	 docker run -p 3000:3000 -td nim.prologue.default
	 sleep 5
	 echo '127.0.0.1' > nim/prologue/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat nim/prologue/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat nim/prologue/ip-default.txt` ENGINE=default LANGUAGE=nim FRAMEWORK=prologue DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=nim.prologue.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
