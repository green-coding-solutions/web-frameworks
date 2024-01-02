build:
	 cd d/vibed && docker build -f .Dockerfile.default -t d.vibed.default .&& cd -
	 docker run -p 3000:3000 -td d.vibed.default
	 sleep 5
	 echo '127.0.0.1' > d/vibed/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat d/vibed/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat d/vibed/ip-default.txt` ENGINE=default LANGUAGE=d FRAMEWORK=vibed DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=d.vibed.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
