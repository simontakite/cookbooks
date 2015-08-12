# cookbook filename: make_temp

# Make a "good enough" random temp directory
until [ -n "$temp_dir" -a ! -d "$temp_dir" ]; do
    temp_dir="/tmp/meaningful_prefix.${RANDOM}${RANDOM}${RANDOM}"
done
mkdir -p -m 0700 $temp_dir \
  || { echo "FATAL: Failed to create temp dir '$temp_dir': $?"; exit 100 }

# Make a "good enough" random temp file in the temp dir
temp_file="$temp_dir/meaningful_prefix.${RANDOM}${RANDOM}${RANDOM}"
touch $temp_file && chmod 0600 $temp_file \
  || { echo "FATAL: Failed to create temp file '$temp_file': $?"; exit 101 }
