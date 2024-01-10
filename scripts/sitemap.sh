#!/bin/bash
base_dir="/home/runner/work/icapito-database/icapito-database/db/metadatas"
base_url="https://www.icapito.it"
dest_file="${base_dir}/../sitemap.xml"
bck_file="${base_dir}/../../backup/sitemap.xml"
replacer="/./"
[[ -f "${bck_file}" ]] && rm -f "${bck_file}"
[[ -f "${dest_file}" ]] && mv "${dest_file}" "${bck_file}"
cd "${base_dir}"
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "${dest_file}"
echo "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">" >> "${dest_file}"
for curr_file in $(find . -type f); do
  mod=$(date -r ${curr_file} +%y-%m-%d)
  name=${curr_file%.*}
  name=$(echo "${base_url}/${name}")
  echo "<url>" >> "${dest_file}"
  echo "<loc>${name}</loc>" >> "${dest_file}"
  echo "<lastmod>${mod}</lastmod>" >> "${dest_file}"
  echo "</url>" >> "${dest_file}"
done
echo "</urlset>" >> "${dest_file}"
sed -i "s|${replacer}|/|g" "${dest_file}"
exit 0
