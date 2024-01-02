build:
	 cd python/baize-asgi && docker build -f .Dockerfile.uvicorn -t python.baize-asgi.uvicorn .&& cd -
	 docker run -p 3000:3000 -td python.baize-asgi.uvicorn
	 sleep 5
	 echo '127.0.0.1' > python/baize-asgi/ip-uvicorn.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/baize-asgi/ip-uvicorn.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/baize-asgi/ip-uvicorn.txt` ENGINE=uvicorn LANGUAGE=python FRAMEWORK=baize-asgi DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.baize-asgi.uvicorn  | xargs docker rm -f
run-all : build.uvicorn collect.uvicorn clean.uvicorn build.hypercorn collect.hypercorn clean.hypercorn build.daphne collect.daphne clean.daphne
