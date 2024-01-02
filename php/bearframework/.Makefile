build:
	 cd php/bearframework && docker build -f .Dockerfile.php-fpm -t php.bearframework.php-fpm .&& cd -
	 docker run -p 3000:3000 -td php.bearframework.php-fpm
	 sleep 5
	 echo '127.0.0.1' > php/bearframework/ip-php-fpm.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/bearframework/ip-php-fpm.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/bearframework/ip-php-fpm.txt` ENGINE=php-fpm LANGUAGE=php FRAMEWORK=bearframework DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.bearframework.php-fpm  | xargs docker rm -f
run-all : build.php-fpm collect.php-fpm clean.php-fpm
