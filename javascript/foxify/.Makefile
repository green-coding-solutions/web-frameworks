build:
	 cd javascript/foxify && docker build -f .Dockerfile.node -t javascript.foxify.node .&& cd -
	 docker run -p 3000:3000 -td javascript.foxify.node
	 sleep 5
	 echo '127.0.0.1' > javascript/foxify/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/foxify/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/foxify/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=foxify DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.foxify.node  | xargs docker rm -f
run-all : build.node collect.node clean.node
