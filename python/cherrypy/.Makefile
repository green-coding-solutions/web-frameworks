build:
	 cd python/cherrypy && docker build -f .Dockerfile.gunicorn -t python.cherrypy.gunicorn .&& cd -
	 docker run -p 3000:3000 -td python.cherrypy.gunicorn
	 sleep 5
	 echo '127.0.0.1' > python/cherrypy/ip-gunicorn.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/cherrypy/ip-gunicorn.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/cherrypy/ip-gunicorn.txt` ENGINE=gunicorn LANGUAGE=python FRAMEWORK=cherrypy DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.cherrypy.gunicorn  | xargs docker rm -f
run-all : build.gunicorn collect.gunicorn clean.gunicorn build.uwsgi collect.uwsgi clean.uwsgi build.waitress collect.waitress clean.waitress
