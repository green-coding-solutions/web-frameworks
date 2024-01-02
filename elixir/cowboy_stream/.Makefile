build:
	 cd elixir/cowboy_stream && docker build -f .Dockerfile.default -t elixir.cowboy_stream.default .&& cd -
	 docker run -p 3000:3000 -td elixir.cowboy_stream.default
	 sleep 5
	 echo '127.0.0.1' > elixir/cowboy_stream/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat elixir/cowboy_stream/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat elixir/cowboy_stream/ip-default.txt` ENGINE=default LANGUAGE=elixir FRAMEWORK=cowboy_stream DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=elixir.cowboy_stream.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
