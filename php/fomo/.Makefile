build:
	 cd php/fomo && docker build -f .Dockerfile.swoole -t php.fomo.swoole .&& cd -
	 docker run -p 3000:3000 -td php.fomo.swoole
	 sleep 5
	 echo '127.0.0.1' > php/fomo/ip-swoole.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/fomo/ip-swoole.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/fomo/ip-swoole.txt` ENGINE=swoole LANGUAGE=php FRAMEWORK=fomo DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.fomo.swoole  | xargs docker rm -f
run-all : build.swoole collect.swoole clean.swoole
