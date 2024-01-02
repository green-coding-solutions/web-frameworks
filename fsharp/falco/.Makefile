build:
	 cd fsharp/falco && docker build -f .Dockerfile.default -t fsharp.falco.default .&& cd -
	 docker run -p 3000:3000 -td fsharp.falco.default
	 sleep 5
	 echo '127.0.0.1' > fsharp/falco/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat fsharp/falco/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat fsharp/falco/ip-default.txt` ENGINE=default LANGUAGE=fsharp FRAMEWORK=falco DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=fsharp.falco.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
