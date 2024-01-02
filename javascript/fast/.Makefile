build:
	 cd javascript/fast && docker build -f .Dockerfile.deno -t javascript.fast.deno .&& cd -
	 docker run -p 3000:3000 -td javascript.fast.deno
	 sleep 5
	 echo '127.0.0.1' > javascript/fast/ip-deno.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/fast/ip-deno.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/fast/ip-deno.txt` ENGINE=deno LANGUAGE=javascript FRAMEWORK=fast DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.fast.deno  | xargs docker rm -f
run-all : build.deno collect.deno clean.deno
