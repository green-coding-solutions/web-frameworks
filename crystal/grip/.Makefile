build:
	 cd crystal/grip && docker build -f .Dockerfile.default -t crystal.grip.default .&& cd -
	 docker run -p 3000:3000 -td crystal.grip.default
	 sleep 5
	 echo '127.0.0.1' > crystal/grip/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat crystal/grip/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat crystal/grip/ip-default.txt` ENGINE=default LANGUAGE=crystal FRAMEWORK=grip DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=crystal.grip.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
