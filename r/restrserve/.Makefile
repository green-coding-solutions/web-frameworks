build:
	 cd r/restrserve && docker build -f .Dockerfile.default -t r.restrserve.default .&& cd -
	 docker run -p 3000:3000 -td r.restrserve.default
	 sleep 5
	 echo '127.0.0.1' > r/restrserve/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat r/restrserve/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat r/restrserve/ip-default.txt` ENGINE=default LANGUAGE=r FRAMEWORK=restrserve DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=r.restrserve.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
