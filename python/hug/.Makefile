build:
	 cd python/hug && docker build -f .Dockerfile.uwsgi -t python.hug.uwsgi .&& cd -
	 docker run -p 3000:3000 -td python.hug.uwsgi
	 sleep 5
	 echo '127.0.0.1' > python/hug/ip-uwsgi.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/hug/ip-uwsgi.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/hug/ip-uwsgi.txt` ENGINE=uwsgi LANGUAGE=python FRAMEWORK=hug DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.hug.uwsgi  | xargs docker rm -f
run-all : build.uwsgi collect.uwsgi clean.uwsgi build.gunicorn collect.gunicorn clean.gunicorn build.waitress collect.waitress clean.waitress
