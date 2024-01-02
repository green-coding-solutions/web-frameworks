build:
	 cd ruby/rack_app && docker build -f .Dockerfile.puma -t ruby.rack_app.puma .&& cd -
	 docker run -p 3000:3000 -td ruby.rack_app.puma
	 sleep 5
	 echo '127.0.0.1' > ruby/rack_app/ip-puma.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat ruby/rack_app/ip-puma.txt`:3000 -v
collect:
	 HOSTNAME=`cat ruby/rack_app/ip-puma.txt` ENGINE=puma LANGUAGE=ruby FRAMEWORK=rack_app DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=ruby.rack_app.puma  | xargs docker rm -f
run-all : build.puma collect.puma clean.puma build.iodine collect.iodine clean.iodine build.falcon collect.falcon clean.falcon
