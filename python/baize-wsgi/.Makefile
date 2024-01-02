build:
	 cd python/baize-wsgi && docker build -f .Dockerfile.gunicorn -t python.baize-wsgi.gunicorn .&& cd -
	 docker run -p 3000:3000 -td python.baize-wsgi.gunicorn
	 sleep 5
	 echo '127.0.0.1' > python/baize-wsgi/ip-gunicorn.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/baize-wsgi/ip-gunicorn.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/baize-wsgi/ip-gunicorn.txt` ENGINE=gunicorn LANGUAGE=python FRAMEWORK=baize-wsgi DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.baize-wsgi.gunicorn  | xargs docker rm -f
run-all : build.gunicorn collect.gunicorn clean.gunicorn build.uwsgi collect.uwsgi clean.uwsgi build.waitress collect.waitress clean.waitress
