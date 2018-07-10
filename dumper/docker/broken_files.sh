#!/usr/bin/env bash

set -e


function containsElement() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}


broken_files=($(find /data/root -name '*' | xargs -i ls -l "{}" 2>&1 | grep 'No such file or directory' | sed "s#.*'\(.*\)'.*#\1#" | sort -r -n | uniq))
echo clean broken files
echo "broken_files '${broken_files[@]}'"
for broken_file in ${broken_files[@]}; do
    parent_dir="$(dirname ${broken_file})"
    echo "parent_dir '${parent_dir}'"
    parent_dir_contents=($(find "${parent_dir}" -maxdepth 1))
    if [ -d "${parent_dir}" ]; then
        echo rm -rf "/tmp${parent_dir}"; rm -rf "/tmp${parent_dir}"
        echo mkdir -p "/tmp${parent_dir}"; mkdir -p "/tmp${parent_dir}"
        for element in ${parent_dir_contents[@]}; do
            if ! containsElement "${element}" "${broken_files[@]}" && [ "${element}" != "${parent_dir}" ]; then
                echo mv "${element}" "/tmp${element}"; mv "${element}" "/tmp${element}"
            fi
        done
        echo rm -rf "${parent_dir}"; rm -rf "${parent_dir}"
        echo mv "/tmp${parent_dir}" "${parent_dir}"; mv "/tmp${parent_dir}" "${parent_dir}"
    fi
done
