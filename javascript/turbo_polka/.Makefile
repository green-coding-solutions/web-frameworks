build:
	 cd javascript/turbo_polka && docker build -f .Dockerfile.turbo -t javascript.turbo_polka.turbo .&& cd -
	 docker run -p 3000:3000 -td javascript.turbo_polka.turbo
	 sleep 5
	 echo '127.0.0.1' > javascript/turbo_polka/ip-turbo.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/turbo_polka/ip-turbo.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/turbo_polka/ip-turbo.txt` ENGINE=turbo LANGUAGE=javascript FRAMEWORK=turbo_polka DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.turbo_polka.turbo  | xargs docker rm -f
run-all : build.turbo collect.turbo clean.turbo
