build:
	 cd javascript/polka && docker build -f .Dockerfile.node -t javascript.polka.node .&& cd -
	 docker run -p 3000:3000 -td javascript.polka.node
	 sleep 5
	 echo '127.0.0.1' > javascript/polka/ip-node.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat javascript/polka/ip-node.txt`:3000 -v
collect:
	 HOSTNAME=`cat javascript/polka/ip-node.txt` ENGINE=node LANGUAGE=javascript FRAMEWORK=polka DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=javascript.polka.node  | xargs docker rm -f
run-all : build.node collect.node clean.node
