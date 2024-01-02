build:
	 cd ruby/syro && docker build -f .Dockerfile.puma -t ruby.syro.puma .&& cd -
	 docker run -p 3000:3000 -td ruby.syro.puma
	 sleep 5
	 echo '127.0.0.1' > ruby/syro/ip-puma.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat ruby/syro/ip-puma.txt`:3000 -v
collect:
	 HOSTNAME=`cat ruby/syro/ip-puma.txt` ENGINE=puma LANGUAGE=ruby FRAMEWORK=syro DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=ruby.syro.puma  | xargs docker rm -f
run-all : build.puma collect.puma clean.puma build.iodine collect.iodine clean.iodine build.falcon collect.falcon clean.falcon
