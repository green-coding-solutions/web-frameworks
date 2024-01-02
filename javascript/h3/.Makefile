build:
	 cd javascript/h3 && docker build -f .Dockerfile.node -t javascript.h3.node .&& cd -
	 docker run -p 3000:3000 -td javascript.h3.node
	 sleep 5
	 echo '127.0.0.1' > javascript/h3/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/h3/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/h3/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=h3 DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.h3.node  | xargs docker rm -f
run-all : build.node collect.node clean.node
