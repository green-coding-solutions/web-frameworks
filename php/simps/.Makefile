build:
	 cd php/simps && docker build -f .Dockerfile.swoole -t php.simps.swoole .&& cd -
	 docker run -p 3000:3000 -td php.simps.swoole
	 sleep 5
	 echo '127.0.0.1' > php/simps/ip-swoole.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/simps/ip-swoole.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/simps/ip-swoole.txt` ENGINE=swoole LANGUAGE=php FRAMEWORK=simps DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.simps.swoole  | xargs docker rm -f
run-all : build.swoole collect.swoole clean.swoole
