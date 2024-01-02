build:
	 cd python/aiohttp && docker build -f .Dockerfile.aiohttp -t python.aiohttp.aiohttp .&& cd -
	 docker run -p 3000:3000 -td python.aiohttp.aiohttp
	 sleep 5
	 echo '127.0.0.1' > python/aiohttp/ip-aiohttp.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/aiohttp/ip-aiohttp.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/aiohttp/ip-aiohttp.txt` ENGINE=aiohttp LANGUAGE=python FRAMEWORK=aiohttp DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.aiohttp.aiohttp  | xargs docker rm -f
run-all : build.aiohttp collect.aiohttp clean.aiohttp build.gunicorn collect.gunicorn clean.gunicorn build.uvloop collect.uvloop clean.uvloop
