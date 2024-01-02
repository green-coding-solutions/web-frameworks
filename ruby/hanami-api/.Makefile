build:
	 cd ruby/hanami-api && docker build -f .Dockerfile.puma -t ruby.hanami-api.puma .&& cd -
	 docker run -p 3000:3000 -td ruby.hanami-api.puma
	 sleep 5
	 echo '127.0.0.1' > ruby/hanami-api/ip-puma.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat ruby/hanami-api/ip-puma.txt`:3000 -v
collect:
	 HOSTNAME=`cat ruby/hanami-api/ip-puma.txt` ENGINE=puma LANGUAGE=ruby FRAMEWORK=hanami-api DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=ruby.hanami-api.puma  | xargs docker rm -f
run-all : build.puma collect.puma clean.puma build.iodine collect.iodine clean.iodine build.falcon collect.falcon clean.falcon
