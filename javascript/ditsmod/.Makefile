build:
	 cd javascript/ditsmod && docker build -f .Dockerfile.node -t javascript.ditsmod.node .&& cd -
	 docker run -p 3000:3000 -td javascript.ditsmod.node
	 sleep 5
	 echo '127.0.0.1' > javascript/ditsmod/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/ditsmod/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/ditsmod/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=ditsmod DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.ditsmod.node  | xargs docker rm -f
run-all : build.node collect.node clean.node
