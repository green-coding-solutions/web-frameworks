build:
	 cd javascript/adonisjs && docker build -f .Dockerfile.node -t javascript.adonisjs.node .&& cd -
	 docker run -p 3000:3000 -td javascript.adonisjs.node
	 sleep 5
	 echo '127.0.0.1' > javascript/adonisjs/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/adonisjs/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/adonisjs/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=adonisjs DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.adonisjs.node  | xargs docker rm -f
run-all : build.node collect.node clean.node
