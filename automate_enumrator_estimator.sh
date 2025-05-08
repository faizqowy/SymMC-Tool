#!/bin/bash

# Directories
cnf_dir="/home/faiz/SymMC/SymMC-Tool/Dataset/local/cnfs_PSB/ds"
perm_dir="/home/faiz/SymMC/SymMC-Tool/Dataset/local/syms/ds"

# Folders to skip
# excluded_folders=("FileSystem" "GEO115" "GraphColoring" "Lists" "MGT066" "Pigeonhole") # For KODKOD
# excluded_folders=("bst-exactly-10-Node" "bst-exactly-9-Node" "bt-exactly-10-Node" "dllist-exactly-8-Node" "dllist-exactly-9-Node" "sortedlist-exactly-10-Node") # for ds
# excluded_folders=("nqueen_10" "nqueen_11" "nqueen_11_blocked" "nqueen_12" "nqueen_9") # for nqueen
# excluded_folders=("basic-auth" "chord" "chordbugmodel" "dijkstra-K-state") # for alloy
excluded_folders=()

runningType="-getmcNSB" # For running type flag there is 3 to choose from -getmcNSB, -kodkodpruning, -getmcFSB

for folder in "$cnf_dir"/*/; do
    name=$(basename "$folder")

    # Skip excluded folders
    if [[ " ${excluded_folders[@]} " =~ " $name " ]]; then
        echo "Skipping $name"
        continue
    fi

    # Find first .cnf file
    cnf_file=$(find "$folder" -maxdepth 1 -type f -name "*.cnf" | sort | head -n 1)
    if [[ -z "$cnf_file" ]]; then
        echo "No .cnf file in $name, skipping"
        continue
    fi

    # Corresponding .perm file in syms folder
    base_name=$(basename "$cnf_file" .cnf)
    perm_file="$perm_dir/$name/$base_name.perm"

    # Check if perm file exists
    if [[ -f "$perm_file" ]]; then
        echo "Running on $name"
        ./Enumerator_Estimator/cmake-build-release/minisat "$runningType" "$cnf_file" "$perm_file"
    else
        echo "Missing .perm file for $base_name in $name, skipping"
    fi
done