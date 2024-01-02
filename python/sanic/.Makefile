build:
	 cd python/sanic && docker build -f .Dockerfile.sanic -t python.sanic.sanic .&& cd -
	 docker run -p 3000:3000 -td python.sanic.sanic
	 sleep 5
	 echo '127.0.0.1' > python/sanic/ip-sanic.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/sanic/ip-sanic.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/sanic/ip-sanic.txt` ENGINE=sanic LANGUAGE=python FRAMEWORK=sanic DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.sanic.sanic  | xargs docker rm -f
run-all : build.sanic collect.sanic clean.sanic build.uvicorn collect.uvicorn clean.uvicorn build.gunicorn collect.gunicorn clean.gunicorn build.hypercorn collect.hypercorn clean.hypercorn
