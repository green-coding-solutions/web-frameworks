build:
	 cd r/httpuv && docker build -f .Dockerfile.default -t r.httpuv.default .&& cd -
	 docker run -p 3000:3000 -td r.httpuv.default
	 sleep 5
	 echo '127.0.0.1' > r/httpuv/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat r/httpuv/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat r/httpuv/ip-default.txt` ENGINE=default LANGUAGE=r FRAMEWORK=httpuv DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=r.httpuv.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
