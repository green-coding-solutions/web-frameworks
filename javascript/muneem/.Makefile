build:
	 cd javascript/muneem && docker build -f .Dockerfile.node -t javascript.muneem.node .&& cd -
	 docker run -p 3000:3000 -td javascript.muneem.node
	 sleep 5
	 echo '127.0.0.1' > javascript/muneem/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/muneem/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/muneem/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=muneem DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.muneem.node  | xargs docker rm -f
run-all : build.node collect.node clean.node
