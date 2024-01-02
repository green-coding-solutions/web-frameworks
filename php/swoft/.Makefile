build:
	 cd php/swoft && docker build -f .Dockerfile.swoole -t php.swoft.swoole .&& cd -
	 docker run -p 3000:3000 -td php.swoft.swoole
	 sleep 5
	 echo '127.0.0.1' > php/swoft/ip-swoole.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/swoft/ip-swoole.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/swoft/ip-swoole.txt` ENGINE=swoole LANGUAGE=php FRAMEWORK=swoft DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.swoft.swoole  | xargs docker rm -f
run-all : build.swoole collect.swoole clean.swoole
