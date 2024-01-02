build:
	 cd python/bottle && docker build -f .Dockerfile.gunicorn -t python.bottle.gunicorn .&& cd -
	 docker run -p 3000:3000 -td python.bottle.gunicorn
	 sleep 5
	 echo '127.0.0.1' > python/bottle/ip-gunicorn.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/bottle/ip-gunicorn.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/bottle/ip-gunicorn.txt` ENGINE=gunicorn LANGUAGE=python FRAMEWORK=bottle DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.bottle.gunicorn  | xargs docker rm -f
run-all : build.gunicorn collect.gunicorn clean.gunicorn build.wsgiref collect.wsgiref clean.wsgiref build.bjoern collect.bjoern clean.bjoern build.cheroot collect.cheroot clean.cheroot build.waitress collect.waitress clean.waitress build.gunicorn collect.gunicorn clean.gunicorn
