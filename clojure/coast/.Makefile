build:
	 cd clojure/coast && docker build -f .Dockerfile.default -t clojure.coast.default .&& cd -
	 docker run -p 3000:3000 -td clojure.coast.default
	 sleep 5
	 echo '127.0.0.1' > clojure/coast/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat clojure/coast/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat clojure/coast/ip-default.txt` ENGINE=default LANGUAGE=clojure FRAMEWORK=coast DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=clojure.coast.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
