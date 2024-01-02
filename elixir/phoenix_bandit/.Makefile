build:
	 cd elixir/phoenix_bandit && docker build -f .Dockerfile.default -t elixir.phoenix_bandit.default .&& cd -
	 docker run -p 3000:3000 -td elixir.phoenix_bandit.default
	 sleep 5
	 echo '127.0.0.1' > elixir/phoenix_bandit/ip-default.txt
	 curl --retry 5 --retry-delay 5 --retry-max-time 180 --retry-connrefused http://`cat elixir/phoenix_bandit/ip-default.txt`:3000 -v
collect:
	 HOSTNAME=`cat elixir/phoenix_bandit/ip-default.txt` ENGINE=default LANGUAGE=elixir FRAMEWORK=phoenix_bandit DATABASE_URL=postgresql://postgres@localhost/benchmark bundle exec rake collect
clean:
	 docker ps -a -q  --filter ancestor=elixir.phoenix_bandit.default  | xargs docker rm -f
run-all : build.default collect.default clean.default
