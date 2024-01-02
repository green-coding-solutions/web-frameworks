build:
	 cd python/nameko && docker build -f .Dockerfile.nameko -t python.nameko.nameko .&& cd -
	 docker run -p 3000:3000 -td python.nameko.nameko
	 sleep 5
	 echo '127.0.0.1' > python/nameko/ip-nameko.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/nameko/ip-nameko.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/nameko/ip-nameko.txt` ENGINE=nameko LANGUAGE=python FRAMEWORK=nameko DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.nameko.nameko  | xargs docker rm -f
run-all : build.nameko collect.nameko clean.nameko
