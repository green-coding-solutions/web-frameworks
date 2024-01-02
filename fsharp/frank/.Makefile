build:
	 cd fsharp/frank && docker build -f .Dockerfile.default -t fsharp.frank.default .&& cd -
	 docker run -p 3000:3000 -td fsharp.frank.default
	 sleep 5
	 echo '127.0.0.1' > fsharp/frank/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat fsharp/frank/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat fsharp/frank/ip-default.txt` ENGINE=default LANGUAGE=fsharp FRAMEWORK=frank DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=fsharp.frank.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
