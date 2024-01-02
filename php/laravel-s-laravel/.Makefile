build:
	 cd php/laravel-s-laravel && docker build -f .Dockerfile.swoole -t php.laravel-s-laravel.swoole .&& cd -
	 docker run -p 3000:3000 -td php.laravel-s-laravel.swoole
	 sleep 5
	 echo '127.0.0.1' > php/laravel-s-laravel/ip-swoole.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/laravel-s-laravel/ip-swoole.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/laravel-s-laravel/ip-swoole.txt` ENGINE=swoole LANGUAGE=php FRAMEWORK=laravel-s-laravel DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.laravel-s-laravel.swoole  | xargs docker rm -f
run-all : build.swoole collect.swoole clean.swoole
