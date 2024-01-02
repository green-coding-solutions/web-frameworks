build:
	 cd php/antidot && docker build -f .Dockerfile.reactphp -t php.antidot.reactphp .&& cd -
	 docker run -p 3000:3000 -td php.antidot.reactphp
	 sleep 5
	 echo '127.0.0.1' > php/antidot/ip-reactphp.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat php/antidot/ip-reactphp.txt`:3000 -v
collect:
	 HOSTNAME=`cat php/antidot/ip-reactphp.txt` ENGINE=reactphp LANGUAGE=php FRAMEWORK=antidot DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=php.antidot.reactphp  | xargs docker rm -f
run-all : build.reactphp collect.reactphp clean.reactphp
