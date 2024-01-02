build:
	 cd javascript/polkadot && docker build -f .Dockerfile.node -t javascript.polkadot.node .&& cd -
	 docker run -p 3000:3000 -td javascript.polkadot.node
	 sleep 5
	 echo '127.0.0.1' > javascript/polkadot/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/polkadot/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/polkadot/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=polkadot DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.polkadot.node  | xargs docker rm -f
run-all : build.node collect.node clean.node
