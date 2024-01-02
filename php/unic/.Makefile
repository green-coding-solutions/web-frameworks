build:
	 cd php/unic && docker build -f .Dockerfile.swoole -t php.unic.swoole .&& cd -
	 docker run -p 3000:3000 -td php.unic.swoole
	 sleep 5
	 echo '127.0.0.1' > php/unic/ip-swoole.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/unic/ip-swoole.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/unic/ip-swoole.txt` ENGINE=swoole LANGUAGE=php FRAMEWORK=unic DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.unic.swoole  | xargs docker rm -f
run-all : build.swoole collect.swoole clean.swoole
