build:
	 cd python/django && docker build -f .Dockerfile.gunicorn -t python.django.gunicorn .&& cd -
	 docker run -p 3000:3000 -td python.django.gunicorn
	 sleep 5
	 echo '127.0.0.1' > python/django/ip-gunicorn.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/django/ip-gunicorn.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/django/ip-gunicorn.txt` ENGINE=gunicorn LANGUAGE=python FRAMEWORK=django DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.django.gunicorn  | xargs docker rm -f
run-all : build.gunicorn collect.gunicorn clean.gunicorn build.uwsgi collect.uwsgi clean.uwsgi build.uvicorn collect.uvicorn clean.uvicorn build.hypercorn collect.hypercorn clean.hypercorn build.daphne collect.daphne clean.daphne
