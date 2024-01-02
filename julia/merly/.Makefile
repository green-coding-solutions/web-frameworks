build:
	 cd julia/merly && docker build -f .Dockerfile.default -t julia.merly.default .&& cd -
	 docker run -p 3000:3000 -td julia.merly.default
	 sleep 5
	 echo '127.0.0.1' > julia/merly/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat julia/merly/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat julia/merly/ip-default.txt` ENGINE=default LANGUAGE=julia FRAMEWORK=merly DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=julia.merly.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
