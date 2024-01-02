build:
	 cd elixir/plug_cowboy && docker build -f .Dockerfile.default -t elixir.plug_cowboy.default .&& cd -
	 docker run -p 3000:3000 -td elixir.plug_cowboy.default
	 sleep 5
	 echo '127.0.0.1' > elixir/plug_cowboy/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat elixir/plug_cowboy/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat elixir/plug_cowboy/ip-default.txt` ENGINE=default LANGUAGE=elixir FRAMEWORK=plug_cowboy DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=elixir.plug_cowboy.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
