build:
	 cd java/struts2 && docker build -f .Dockerfile.default -t java.struts2.default .&& cd -
	 docker run -p 3000:3000 -td java.struts2.default
	 sleep 5
	 echo '127.0.0.1' > java/struts2/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat java/struts2/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat java/struts2/ip-default.txt` ENGINE=default LANGUAGE=java FRAMEWORK=struts2 DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=java.struts2.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
