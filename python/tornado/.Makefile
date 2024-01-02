build:
	 cd python/tornado && docker build -f .Dockerfile.tornado -t python.tornado.tornado .&& cd -
	 docker run -p 3000:3000 -td python.tornado.tornado
	 sleep 5
	 echo '127.0.0.1' > python/tornado/ip-tornado.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/tornado/ip-tornado.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/tornado/ip-tornado.txt` ENGINE=tornado LANGUAGE=python FRAMEWORK=tornado DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.tornado.tornado  | xargs docker rm -f
run-all : build.tornado collect.tornado clean.tornado
