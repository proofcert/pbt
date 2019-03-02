#!/usr/bin/env bash

# Original description follows:
#
# This script interfaces with Bedwyr to generate (simple!) random choices on
# QuickCheck-style certificates. It relies on internal conventions and is
# therefore brittle on its own, while offering a simple means of automating
# programmatic aspects of clerks and experts where Bedwyr is lacking.
#
# This variation is modified to interact with Elpi instead of Bedwyr.

# Launch client as coprocess and rig its standard input and output
coproc elpi (
	# Single command-line argument pointing to harness file
	elpi $1 -test
) # No redirects needed

# Seed random number generator (TODO parameterize, use better generator)
RANDOM=42
# For each standard-format query, parse and generate weighed choice
while read -u ${elpi[0]} line # -t 0? # lP: -d omitted
do
	echo ">> $line"
	#regex="\"Toss a coin .* on \(\"([0-9]+)\",\"([0-9]+)\".*"
	regex="\"Toss a coin .*"
	if [[ $line =~ $regex ]]; then
		# Scale number to local weights (note the limited resolution!)
		#choice=$(( (BASH_REMATCH[1] + BASH_REMATCH[2]) * RANDOM / 32767 > BASH_REMATCH[1] ))
		choice=$(( RANDOM > 16383 ))
		echo "<< $choice"
		echo "$choice." >&${elpi[1]}
	else
		echo "No match: $line"
	fi
done

echo "Done"
wait $elpi_PID
exit 0
