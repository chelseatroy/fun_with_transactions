declare -a COMMANDS=("GET" "SET" "COUNT" "DELETE")

for COMMAND in "${COMMANDS[@]}"
do
	chmod +x "$COMMAND"
done

mkdir -p ~/bin

for COMMAND in "${COMMANDS[@]}"
do
	cp "$COMMAND" ~/bin
done

cp database.rb ~/bin
export PATH=$PATH":$HOME/bin"