build:
	 cd perl/kossy && docker build -f .Dockerfile.gazelle -t perl.kossy.gazelle .&& cd -
	 docker run -p 3000:3000 -td perl.kossy.gazelle
	 sleep 5
	 echo '127.0.0.1' > perl/kossy/ip-gazelle.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat perl/kossy/ip-gazelle.txt`:3000 -v
collect:
	 HOSTNAME=`cat perl/kossy/ip-gazelle.txt` ENGINE=gazelle LANGUAGE=perl FRAMEWORK=kossy DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=perl.kossy.gazelle  | xargs docker rm -f
run-all : build.gazelle collect.gazelle clean.gazelle
