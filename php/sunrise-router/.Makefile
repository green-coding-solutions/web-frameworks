build:
	 cd php/sunrise-router && docker build -f .Dockerfile.php-fpm -t php.sunrise-router.php-fpm .&& cd -
	 docker run -p 3000:3000 -td php.sunrise-router.php-fpm
	 sleep 5
	 echo '127.0.0.1' > php/sunrise-router/ip-php-fpm.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/sunrise-router/ip-php-fpm.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/sunrise-router/ip-php-fpm.txt` ENGINE=php-fpm LANGUAGE=php FRAMEWORK=sunrise-router DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.sunrise-router.php-fpm  | xargs docker rm -f
run-all : build.php-fpm collect.php-fpm clean.php-fpm
