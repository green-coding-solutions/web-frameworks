build:
	 cd kotlin/http4k && docker build -f .Dockerfile.default -t kotlin.http4k.default .&& cd -
	 docker run -p 3000:3000 -td kotlin.http4k.default
	 sleep 5
	 echo '127.0.0.1' > kotlin/http4k/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat kotlin/http4k/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat kotlin/http4k/ip-default.txt` ENGINE=default LANGUAGE=kotlin FRAMEWORK=http4k DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=kotlin.http4k.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
