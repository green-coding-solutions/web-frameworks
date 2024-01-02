build:
	 cd javascript/happyx && docker build -f .Dockerfile.happyx -t javascript.happyx.happyx .&& cd -
	 docker run -p 3000:3000 -td javascript.happyx.happyx
	 sleep 5
	 echo '127.0.0.1' > javascript/happyx/ip-happyx.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/happyx/ip-happyx.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/happyx/ip-happyx.txt` ENGINE=happyx LANGUAGE=javascript FRAMEWORK=happyx DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.happyx.happyx  | xargs docker rm -f
run-all : build.happyx collect.happyx clean.happyx
