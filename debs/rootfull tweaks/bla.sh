#!/bin/bash

# Set the path to the current directory
ROOTFULL_TWEAKS_FOLDER=$(pwd)

# Loop through each .deb file in the folder
for deb_file in "$ROOTFULL_TWEAKS_FOLDER"/*.deb; do
    # Extract the contents of the .deb file
    temp_dir=$(mktemp -d)
    dpkg-deb -R "$deb_file" "$temp_dir"

    # Modify the control file to remove specific patterns from the "Depends" section
    control_file="$temp_dir/DEBIAN/control"
    sed -i '/^Depends:/ s/, com.flame.xinam1ne//g' "$control_file"
    sed -i '/^Depends:/ s/, xyz.cypwn.xinam1ne//g' "$control_file"
    sed -i '/^Depends:/ s/| com.flame.xinam1ne//g' "$control_file"
    sed -i '/^Depends:/ s/| xyz.cypwn.xinam1ne//g' "$control_file"

    # Repackage the modified contents back into a .deb file
    new_deb_file="${deb_file%.deb}_modified.deb"
    dpkg-deb -b "$temp_dir" "$new_deb_file"

    # Clean up temporary directory
    rm -rf "$temp_dir"

    echo "Modified $deb_file and created $new_deb_file"
done
