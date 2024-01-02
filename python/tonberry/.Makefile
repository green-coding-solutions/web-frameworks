build:
	 cd python/tonberry && docker build -f .Dockerfile.uvicorn -t python.tonberry.uvicorn .&& cd -
	 docker run -p 3000:3000 -td python.tonberry.uvicorn
	 sleep 5
	 echo '127.0.0.1' > python/tonberry/ip-uvicorn.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/tonberry/ip-uvicorn.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/tonberry/ip-uvicorn.txt` ENGINE=uvicorn LANGUAGE=python FRAMEWORK=tonberry DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.tonberry.uvicorn  | xargs docker rm -f
run-all : build.uvicorn collect.uvicorn clean.uvicorn build.hypercorn collect.hypercorn clean.hypercorn
