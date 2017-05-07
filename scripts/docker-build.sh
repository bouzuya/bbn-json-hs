#!/bin/bash

repo='bouzuya/bbn-json-hs'
project_dir="$(stack path --project-root)"
tmp_dir="${project_dir}/.tmp"
dist_dir="${project_dir}/$(stack path --dist-dir)"
exe_path="${dist_dir}/build/bbn-json-hs-exe/bbn-json-hs-exe"

stack build
test -d "${tmp_dir}" || mkdir -p "${tmp_dir}"
cp "${project_dir}/Dockerfile" "${tmp_dir}"
cp "${exe_path}" "${tmp_dir}"
docker build -t "${repo}" "${tmp_dir}"

