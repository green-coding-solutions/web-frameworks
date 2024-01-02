build:
	 cd javascript/opine && docker build -f .Dockerfile.deno -t javascript.opine.deno .&& cd -
	 docker run -p 3000:3000 -td javascript.opine.deno
	 sleep 5
	 echo '127.0.0.1' > javascript/opine/ip-deno.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/opine/ip-deno.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/opine/ip-deno.txt` ENGINE=deno LANGUAGE=javascript FRAMEWORK=opine DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.opine.deno  | xargs docker rm -f
run-all : build.deno collect.deno clean.deno
