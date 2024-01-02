build:
	 cd javascript/hono && docker build -f .Dockerfile.node -t javascript.hono.node .&& cd -
	 docker run -p 3000:3000 -td javascript.hono.node
	 sleep 5
	 echo '127.0.0.1' > javascript/hono/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/hono/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/hono/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=hono DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.hono.node  | xargs docker rm -f
run-all : build.node collect.node clean.node
