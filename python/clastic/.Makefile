build:
	 cd python/clastic && docker build -f .Dockerfile.gunicorn -t python.clastic.gunicorn .&& cd -
	 docker run -p 3000:3000 -td python.clastic.gunicorn
	 sleep 5
	 echo '127.0.0.1' > python/clastic/ip-gunicorn.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/clastic/ip-gunicorn.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/clastic/ip-gunicorn.txt` ENGINE=gunicorn LANGUAGE=python FRAMEWORK=clastic DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.clastic.gunicorn  | xargs docker rm -f
run-all : build.gunicorn collect.gunicorn clean.gunicorn build.uwsgi collect.uwsgi clean.uwsgi build.waitress collect.waitress clean.waitress
