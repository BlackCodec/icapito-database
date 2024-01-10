#!/bin/bash
base_dir="/home/runner/work/icapito-database/icapito-database/db/metadatas/articles/"
base_url="https://www.icapito.it"
dest_file="${base_dir}/../../feed-rss.xml"
bck_file="${base_dir}/../../../backup/feed-rss.xml"
replacer="/./"
[[ -f "${bck_file}" ]] && rm -f "${bck_file}"
[[ -f "${dest_file}" ]] && mv "${dest_file}" "${bck_file}"
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "${dest_file}"
echo "<rss version=\"2.0\">" >> "${dest_file}"
echo " <channel>" >> "${dest_file}"
echo "  <title>iCapito</title>" >> "${dest_file}"
echo "  <link>https://www.icapito.it</link>" >> "${dest_file}"
echo "  <description>Ex UndeR A TraiN and BlackGroup</description>" >> "${dest_file}"
echo "  <lastBuildDate>$(date -R)</lastBuildDate>" >> "${dest_file}"
echo "  <language>it-IT</language>" >> "${dest_file}"
year="$(date +%Y)"
month="$(date +%m)"
cd "${base_dir}/${year}/${month}"
content=""
for day in $(ls -1); do
  for curr_file_name in $(ls -1 "./${day}/"); do
    curr_file="${base_dir}/${year}/${month}/${day}/${curr_file_name}"
    title=$(cat ${curr_file} | jq '.title')
    desc=$(cat ${curr_file} | jq '.description')
    link=${curr_file_name%.*}
    link=$(echo "${base_url}/${year}/${month}/${day}/${link}")
    temp=$(echo "  <item>"; echo "   <title>${title}</title>"; echo "   <link>${link}</link>";  echo "   <description>${desc}</description>"; echo "  </item>")
    content="${temp}${content}"
  done
done
echo "${content}" >> "${dest_file}"
echo " </channel>" >> "${dest_file}"
echo "</rss>" >> "${dest_file}"
sed -i "s|${replacer}|/|g" "${dest_file}"
exit 0
