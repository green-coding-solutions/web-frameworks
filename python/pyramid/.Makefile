build:
	 cd python/pyramid && docker build -f .Dockerfile.gunicorn -t python.pyramid.gunicorn .&& cd -
	 docker run -p 3000:3000 -td python.pyramid.gunicorn
	 sleep 5
	 echo '127.0.0.1' > python/pyramid/ip-gunicorn.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/pyramid/ip-gunicorn.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/pyramid/ip-gunicorn.txt` ENGINE=gunicorn LANGUAGE=python FRAMEWORK=pyramid DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.pyramid.gunicorn  | xargs docker rm -f
run-all : build.gunicorn collect.gunicorn clean.gunicorn build.uwsgi collect.uwsgi clean.uwsgi
