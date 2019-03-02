#!/bin/sh

if [ "$1" == "ADDMOD" ]; then
	ADDMOD=y
fi

for OPT in $@; do 
	KEY=${OPT%=*}
	VAL=${OPT#*=}

	if [ "$ADDMOD" != "$(awk -F"=" -v KEY="CONFIG_$KEY" '$1 == "" {print $2}' .config)" ]; then
		echo "ADDMOD mode: Isn't builtin. Add as module"
		sed -i "s|.*CONFIG_$KEY.*|CONFIG_$KEY=$VAL|" .config
		exit;
	fi

	if grep "CONFIG_$KEY" .config; then
		echo "Modify existing value"
		sed -i "s|.*CONFIG_$KEY.*|CONFIG_$KEY=$VAL|" .config
	else
		echo "Add new config line"
		echo "CONFIG_$KEY=$VAL" >> .config
	fi
done
