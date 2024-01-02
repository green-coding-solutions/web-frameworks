build:
	 cd python/emmett && docker build -f .Dockerfile.emmett -t python.emmett.emmett .&& cd -
	 docker run -p 3000:3000 -td python.emmett.emmett
	 sleep 5
	 echo '127.0.0.1' > python/emmett/ip-emmett.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/emmett/ip-emmett.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/emmett/ip-emmett.txt` ENGINE=emmett LANGUAGE=python FRAMEWORK=emmett DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.emmett.emmett  | xargs docker rm -f
run-all : build.emmett collect.emmett clean.emmett build.gunicorn collect.gunicorn clean.gunicorn
