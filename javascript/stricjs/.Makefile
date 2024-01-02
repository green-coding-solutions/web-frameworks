build:
	 cd javascript/stricjs && docker build -f .Dockerfile.bun -t javascript.stricjs.bun .&& cd -
	 docker run -p 3000:3000 -td javascript.stricjs.bun
	 sleep 5
	 echo '127.0.0.1' > javascript/stricjs/ip-bun.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/stricjs/ip-bun.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/stricjs/ip-bun.txt` ENGINE=bun LANGUAGE=javascript FRAMEWORK=stricjs DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.stricjs.bun  | xargs docker rm -f
run-all : build.bun collect.bun clean.bun
