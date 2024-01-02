build:
	 cd javascript/iotjs-express && docker build -f .Dockerfile.node -t javascript.iotjs-express.node .&& cd -
	 docker run -p 3000:3000 -td javascript.iotjs-express.node
	 sleep 5
	 echo '127.0.0.1' > javascript/iotjs-express/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/iotjs-express/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/iotjs-express/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=iotjs-express DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.iotjs-express.node  | xargs docker rm -f
run-all : build.node collect.node clean.node
