build:
	 cd v/pico && docker build -f .Dockerfile.default -t v.pico.default .&& cd -
	 docker run -p 3000:3000 -td v.pico.default
	 sleep 5
	 echo '127.0.0.1' > v/pico/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat v/pico/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat v/pico/ip-default.txt` ENGINE=default LANGUAGE=v FRAMEWORK=pico DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=v.pico.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
