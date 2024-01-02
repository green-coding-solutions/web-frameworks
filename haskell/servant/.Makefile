build:
	 cd haskell/servant && docker build -f .Dockerfile.default -t haskell.servant.default .&& cd -
	 docker run -p 3000:3000 -td haskell.servant.default
	 sleep 5
	 echo '127.0.0.1' > haskell/servant/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat haskell/servant/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat haskell/servant/ip-default.txt` ENGINE=default LANGUAGE=haskell FRAMEWORK=servant DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=haskell.servant.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
