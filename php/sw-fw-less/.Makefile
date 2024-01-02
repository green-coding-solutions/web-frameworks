build:
	 cd php/sw-fw-less && docker build -f .Dockerfile.swoole -t php.sw-fw-less.swoole .&& cd -
	 docker run -p 3000:3000 -td php.sw-fw-less.swoole
	 sleep 5
	 echo '127.0.0.1' > php/sw-fw-less/ip-swoole.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/sw-fw-less/ip-swoole.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/sw-fw-less/ip-swoole.txt` ENGINE=swoole LANGUAGE=php FRAMEWORK=sw-fw-less DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.sw-fw-less.swoole  | xargs docker rm -f
run-all : build.swoole collect.swoole clean.swoole
