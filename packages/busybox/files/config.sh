#!/bin/sh

for OPT in $@; do 
	KEY=${OPT%=*}
	VAL=${OPT#*=}

	if grep "CONFIG_$KEY" .config; then
		sed -i "s|.*CONFIG_$KEY.*|CONFIG_$KEY=$VAL|" .config
	else
		echo "CONFIG_$KEY=$VAL" >> .config
	fi
done
