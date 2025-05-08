#!/bin/bash

# Directory containing .als spec files
spec_dir="/home/faiz/SymMC/SymMC-Tool/Dataset/specs/queens"

# Base directories for SAT and symmetry info
sat_base_dir="/home/faiz/SymMC/SymMC-Tool/Dataset/local/cnfs_PSB/queens"
sym_base_dir="/home/faiz/SymMC/SymMC-Tool/Dataset/local/syms/queens"

# Folders (base names) to skip
excluded_folders=()

# Check if sat_base_dir and sym_base_dir exist
if [[ ! -d "$sat_base_dir" ]]; then
    echo "Creating directory: $sat_base_dir"
    mkdir -p "$sat_base_dir"
fi
if [[ ! -d "$sym_base_dir" ]]; then
    echo "Creating directory: $sym_base_dir"
    mkdir -p "$sym_base_dir"
fi

# Loop over each .als file in the spec directory
for spec_file in "$spec_dir"/*.als; do
    base_name=$(basename "$spec_file" .als)

    if [[ " ${excluded_folders[@]} " =~ " $base_name " ]]; then
        echo "Skipping $base_name"
        continue
    fi

    echo "Running ./Enhanced_Kodkod/run.sh for $base_name"
    ./Enhanced_Kodkod/run.sh "$spec_file" "$sat_base_dir" "$sym_base_dir"
done
