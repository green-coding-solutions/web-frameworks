build:
	 cd perl/dancer2 && docker build -f .Dockerfile.gazelle -t perl.dancer2.gazelle .&& cd -
	 docker run -p 3000:3000 -td perl.dancer2.gazelle
	 sleep 5
	 echo '127.0.0.1' > perl/dancer2/ip-gazelle.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat perl/dancer2/ip-gazelle.txt`:3000 -v
collect:
	 HOSTNAME=`cat perl/dancer2/ip-gazelle.txt` ENGINE=gazelle LANGUAGE=perl FRAMEWORK=dancer2 DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=perl.dancer2.gazelle  | xargs docker rm -f
run-all : build.gazelle collect.gazelle clean.gazelle
