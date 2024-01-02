build:
	 cd fsharp/suave && docker build -f .Dockerfile.default -t fsharp.suave.default .&& cd -
	 docker run -p 3000:3000 -td fsharp.suave.default
	 sleep 5
	 echo '127.0.0.1' > fsharp/suave/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat fsharp/suave/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat fsharp/suave/ip-default.txt` ENGINE=default LANGUAGE=fsharp FRAMEWORK=suave DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=fsharp.suave.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
