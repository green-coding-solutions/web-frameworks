build:
	 cd php/mixphp-workerman && docker build -f .Dockerfile.workerman -t php.mixphp-workerman.workerman .&& cd -
	 docker run -p 3000:3000 -td php.mixphp-workerman.workerman
	 sleep 5
	 echo '127.0.0.1' > php/mixphp-workerman/ip-workerman.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/mixphp-workerman/ip-workerman.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/mixphp-workerman/ip-workerman.txt` ENGINE=workerman LANGUAGE=php FRAMEWORK=mixphp-workerman DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.mixphp-workerman.workerman  | xargs docker rm -f
run-all : build.workerman collect.workerman clean.workerman
