build:
	 cd java/spark && docker build -f .Dockerfile.default -t java.spark.default .&& cd -
	 docker run -p 3000:3000 -td java.spark.default
	 sleep 5
	 echo '127.0.0.1' > java/spark/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat java/spark/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat java/spark/ip-default.txt` ENGINE=default LANGUAGE=java FRAMEWORK=spark DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=java.spark.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
