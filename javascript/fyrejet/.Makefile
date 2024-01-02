build:
	 cd javascript/fyrejet && docker build -f .Dockerfile.node -t javascript.fyrejet.node .&& cd -
	 docker run -p 3000:3000 -td javascript.fyrejet.node
	 sleep 5
	 echo '127.0.0.1' > javascript/fyrejet/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/fyrejet/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/fyrejet/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=fyrejet DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.fyrejet.node  | xargs docker rm -f
run-all : build.node collect.node clean.node
