build:
	 cd javascript/bunicorn && docker build -f .Dockerfile.bun -t javascript.bunicorn.bun .&& cd -
	 docker run -p 3000:3000 -td javascript.bunicorn.bun
	 sleep 5
	 echo '127.0.0.1' > javascript/bunicorn/ip-bun.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/bunicorn/ip-bun.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/bunicorn/ip-bun.txt` ENGINE=bun LANGUAGE=javascript FRAMEWORK=bunicorn DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.bunicorn.bun  | xargs docker rm -f
run-all : build.bun collect.bun clean.bun
