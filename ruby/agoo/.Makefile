build:
	 cd ruby/agoo && docker build -f .Dockerfile.agoo -t ruby.agoo.agoo .&& cd -
	 docker run -p 3000:3000 -td ruby.agoo.agoo
	 sleep 5
	 echo '127.0.0.1' > ruby/agoo/ip-agoo.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat ruby/agoo/ip-agoo.txt`:3000 -v
collect:
	 HOSTNAME=`cat ruby/agoo/ip-agoo.txt` ENGINE=agoo LANGUAGE=ruby FRAMEWORK=agoo DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=ruby.agoo.agoo  | xargs docker rm -f
run-all : build.agoo collect.agoo clean.agoo
