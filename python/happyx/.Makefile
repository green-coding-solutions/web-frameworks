build:
	 cd python/happyx && docker build -f .Dockerfile.happyx -t python.happyx.happyx .&& cd -
	 docker run -p 3000:3000 -td python.happyx.happyx
	 sleep 5
	 echo '127.0.0.1' > python/happyx/ip-happyx.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat python/happyx/ip-happyx.txt`:3000 -v
collect:
	 HOSTNAME=`cat python/happyx/ip-happyx.txt` ENGINE=happyx LANGUAGE=python FRAMEWORK=happyx DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=python.happyx.happyx  | xargs docker rm -f
run-all : build.happyx collect.happyx clean.happyx
