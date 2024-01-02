build:
	 cd ruby/rails && docker build -f .Dockerfile.puma -t ruby.rails.puma .&& cd -
	 docker run -p 3000:3000 -td ruby.rails.puma
	 sleep 5
	 echo '127.0.0.1' > ruby/rails/ip-puma.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat ruby/rails/ip-puma.txt`:3000 -v
collect:
	 HOSTNAME=`cat ruby/rails/ip-puma.txt` ENGINE=puma LANGUAGE=ruby FRAMEWORK=rails DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=ruby.rails.puma  | xargs docker rm -f
run-all : build.puma collect.puma clean.puma build.iodine collect.iodine clean.iodine build.falcon collect.falcon clean.falcon
