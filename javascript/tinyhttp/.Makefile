build:
	 cd javascript/tinyhttp && docker build -f .Dockerfile.node -t javascript.tinyhttp.node .&& cd -
	 docker run -p 3000:3000 -td javascript.tinyhttp.node
	 sleep 5
	 echo '127.0.0.1' > javascript/tinyhttp/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/tinyhttp/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/tinyhttp/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=tinyhttp DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.tinyhttp.node  | xargs docker rm -f
run-all : build.node collect.node clean.node
