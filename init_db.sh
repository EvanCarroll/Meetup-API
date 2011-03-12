#!/bin/sh

echo "Re-initializing DB";

for i in sql/*;
	do echo $i && psql -d meetup -f $i;
done;
