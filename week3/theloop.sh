# use "#!" to say it's bash (special type of command)
# < file: read stdin from file
# standard in (stdin) <
# standard out (stdout) >
# standard error (stderr) 2>

#!/bin/bash

for file in *.csv; do
    echo "$file has $(wc -l < $file) lines"
done

