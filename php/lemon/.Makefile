build:
	 cd php/lemon && docker build -f .Dockerfile.php-fpm -t php.lemon.php-fpm .&& cd -
	 docker run -p 3000:3000 -td php.lemon.php-fpm
	 sleep 5
	 echo '127.0.0.1' > php/lemon/ip-php-fpm.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/lemon/ip-php-fpm.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/lemon/ip-php-fpm.txt` ENGINE=php-fpm LANGUAGE=php FRAMEWORK=lemon DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.lemon.php-fpm  | xargs docker rm -f
run-all : build.php-fpm collect.php-fpm clean.php-fpm
