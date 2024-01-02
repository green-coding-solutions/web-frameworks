build:
	 cd python/klein && docker build -f .Dockerfile.twisted -t python.klein.twisted .&& cd -
	 docker run -p 3000:3000 -td python.klein.twisted
	 sleep 5
	 echo '127.0.0.1' > python/klein/ip-twisted.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/klein/ip-twisted.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/klein/ip-twisted.txt` ENGINE=twisted LANGUAGE=python FRAMEWORK=klein DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.klein.twisted  | xargs docker rm -f
run-all : build.twisted collect.twisted clean.twisted
