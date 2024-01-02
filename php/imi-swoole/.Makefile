build:
	 cd php/imi-swoole && docker build -f .Dockerfile.swoole -t php.imi-swoole.swoole .&& cd -
	 docker run -p 3000:3000 -td php.imi-swoole.swoole
	 sleep 5
	 echo '127.0.0.1' > php/imi-swoole/ip-swoole.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/imi-swoole/ip-swoole.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/imi-swoole/ip-swoole.txt` ENGINE=swoole LANGUAGE=php FRAMEWORK=imi-swoole DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.imi-swoole.swoole  | xargs docker rm -f
run-all : build.swoole collect.swoole clean.swoole
