#!/bin/bash
base_dir="/home/runner/work/icapito-database/icapito-database/db/metadatas"
base_url="https://www.icapito.it"
dest_file="${base_dir}/../sitemap.xml"
bck_file="${base_dir}/../../backup/sitemap.xml"
replacer="/./"
[[ -f "${bck_file}" ]] && rm -f "${bck_file}"

cd "${base_dir}"
if [[ ! -f "${dest_file}" ]]; then
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "${dest_file}"
  echo "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">" >> "${dest_file}"
else 
  cp "${dest_file}" "${bck_file}"
  sed -i '$ d' "${dest_file}"
fi
for curr_file in $(find . -type f -not -path "./draft/*"); do
  mod=$(date -r ${curr_file} +%Y-%m-%d)
  name=${curr_file%.*}
  name=$(echo "${base_url}/${name}")
  name=$(echo "${name/\/.\//}")
  if [[ $(cat "${dest_file}" | grep "${name}" | wc -l) < 0 ]]; then
    echo "<url>" >> "${dest_file}"
    echo "<loc>${name}</loc>" >> "${dest_file}"
    echo "<lastmod>${mod}</lastmod>" >> "${dest_file}"
    echo "</url>" >> "${dest_file}"
  fi
done
echo "</urlset>" >> "${dest_file}"
sed -i "s|${replacer}|/|g" "${dest_file}"
exit 0
