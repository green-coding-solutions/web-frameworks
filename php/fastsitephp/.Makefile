build:
	 cd php/fastsitephp && docker build -f .Dockerfile.php-fpm -t php.fastsitephp.php-fpm .&& cd -
	 docker run -p 3000:3000 -td php.fastsitephp.php-fpm
	 sleep 5
	 echo '127.0.0.1' > php/fastsitephp/ip-php-fpm.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/fastsitephp/ip-php-fpm.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/fastsitephp/ip-php-fpm.txt` ENGINE=php-fpm LANGUAGE=php FRAMEWORK=fastsitephp DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.fastsitephp.php-fpm  | xargs docker rm -f
run-all : build.php-fpm collect.php-fpm clean.php-fpm
