build:
	 cd php/mark && docker build -f .Dockerfile.workerman -t php.mark.workerman .&& cd -
	 docker run -p 3000:3000 -td php.mark.workerman
	 sleep 5
	 echo '127.0.0.1' > php/mark/ip-workerman.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/mark/ip-workerman.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/mark/ip-workerman.txt` ENGINE=workerman LANGUAGE=php FRAMEWORK=mark DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.mark.workerman  | xargs docker rm -f
run-all : build.workerman collect.workerman clean.workerman
