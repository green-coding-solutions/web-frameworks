build:
	 cd clojure/luminus && docker build -f .Dockerfile.default -t clojure.luminus.default .&& cd -
	 docker run -p 3000:3000 -td clojure.luminus.default
	 sleep 5
	 echo '127.0.0.1' > clojure/luminus/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat clojure/luminus/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat clojure/luminus/ip-default.txt` ENGINE=default LANGUAGE=clojure FRAMEWORK=luminus DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=clojure.luminus.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
