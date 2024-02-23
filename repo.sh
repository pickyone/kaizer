#!/bin/bash

rm -rf Packages Packages.bz2 Packages.gz Packages.zst Release
dpkg-scanpackages -m debs > Packages
bzip2 -k Packages
gzip -k Packages
zstd -19 Packages
cp Base Release

# Calculate sizes and hashes using SHA-512
packages_size=$(ls -l Packages | awk '{print $5,$9}')
packages_sha512=$(sha512sum Packages | awk '{print $1}')

# Append to Release file
echo "SHA512:" >> Release
echo " $packages_sha512 $packages_size" >> Release

# Process all .deb files recursively in debs directory
find debs -type f -name '*.deb' -exec sh -c '
    deb_file="$1"
    deb_size=$(ls -l "$deb_file" | awk "{print \$5,\$9}")
    deb_sha512=$(sha512sum "$deb_file" | awk "{print \$1}")
    echo " $deb_sha512 $deb_size" >> Release
' sh {} \;

echo "Done"
