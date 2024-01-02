build:
	 cd python/apidaora && docker build -f .Dockerfile.uvicorn -t python.apidaora.uvicorn .&& cd -
	 docker run -p 3000:3000 -td python.apidaora.uvicorn
	 sleep 5
	 echo '127.0.0.1' > python/apidaora/ip-uvicorn.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/apidaora/ip-uvicorn.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/apidaora/ip-uvicorn.txt` ENGINE=uvicorn LANGUAGE=python FRAMEWORK=apidaora DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.apidaora.uvicorn  | xargs docker rm -f
run-all : build.uvicorn collect.uvicorn clean.uvicorn build.hypercorn collect.hypercorn clean.hypercorn build.daphne collect.daphne clean.daphne
