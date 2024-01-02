build:
	 cd php/comet && docker build -f .Dockerfile.workerman -t php.comet.workerman .&& cd -
	 docker run -p 3000:3000 -td php.comet.workerman
	 sleep 5
	 echo '127.0.0.1' > php/comet/ip-workerman.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/comet/ip-workerman.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/comet/ip-workerman.txt` ENGINE=workerman LANGUAGE=php FRAMEWORK=comet DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.comet.workerman  | xargs docker rm -f
run-all : build.workerman collect.workerman clean.workerman
