#!/bin/bash
base_dir="/home/runner/work/icapito-database/icapito-database/db/"
base_url="https://www.icapito.it"
cd ${base_dir}
[[ -f sitemap_old.xml ]] && rm -f ${base_dir}/sitemap_old.xml
[[ -f sitemap.xml ]] && mv ${base_dir}/sitemap.xml ${base_dir}/sitemap_old.xml
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > sitemap.xml
echo "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">" >> sitemap.xml
for curr_file in $(find . -type f); do
  if [[ "${curr_file}" == "feed-rss.xml" ]] || [[ "${curr_file}" == "sitemap.xml" ]] || [[ "${curr_file}" == "sitemap_old.xml" ]]; then
    continue
  fi
  mod=$(date -r ${curr_file} +%y-%m-%d)
  name=$(echo "${curr_file}" | sed "s/.xml$//")
  name=$(echo "${base_url}/${name}")
  echo "<url>" >> sitemap.xml
  echo "<loc>${name}</loc>" >> sitemap.xml
  echo "<lastmod>${mod}</lastmod>" >> sitemap.xml
  echo "</url>" >> sitemap.xml
done
echo "</urlset>" >> sitemap.xml
exit 0
