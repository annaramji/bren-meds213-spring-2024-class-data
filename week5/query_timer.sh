#!/bin/bash

# get current time and store it
# loop num_reps times
#     duckdb db_file query
# end loop
# get current time
# compute elapsed time
# divide elapsed time by num_reps
# write output


# check if all required arguments are provided
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 label num_reps query db_file csv_file"
    exit 1
fi

# assign the arguments to variables
label="$1" # explanatory label that will be output
num_reps="$2" # number of repetitions
query="$3" # SQL query to run
db_file="$4" # database file
csv_file="$5" # CSV file to create or append to

# get current (start) time and store it
start_time=$(date +%s)

# loop num_reps times

for i in $(seq "$num_reps"); do
    duckdb "$db_file" -c "$query"
done

# get end time
end_time=$(date +%s)

# calculate the elapsed time and average time per query
elapsed_time=$((end_time - start_time))
avg_time=$(bc -l <<< "$elapsed_time / $num_reps") # using -l for more precision

# write output (append to csv_file)
echo "$label,$avg_time" >> "$csv_file"