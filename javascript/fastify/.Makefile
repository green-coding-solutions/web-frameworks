build:
	 cd javascript/fastify && docker build -f .Dockerfile.node -t javascript.fastify.node .&& cd -
	 docker run -p 3000:3000 -td javascript.fastify.node
	 sleep 5
	 echo '127.0.0.1' > javascript/fastify/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/fastify/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/fastify/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=fastify DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.fastify.node  | xargs docker rm -f
run-all : build.node collect.node clean.node
