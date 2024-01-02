build:
	 cd v/vex && docker build -f .Dockerfile.default -t v.vex.default .&& cd -
	 docker run -p 3000:3000 -td v.vex.default
	 sleep 5
	 echo '127.0.0.1' > v/vex/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat v/vex/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat v/vex/ip-default.txt` ENGINE=default LANGUAGE=v FRAMEWORK=vex DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=v.vex.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
