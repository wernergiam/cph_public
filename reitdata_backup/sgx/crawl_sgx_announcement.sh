current_basename=`basename $PWD`
echo $current_basename
if [ "$current_basename" != "reitdata" ] ; then
    cd public_html/reitdata
    echo $PWD
fi

curl \
--header "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:49.0) Gecko/20100101 Firefox/49.0" \
-c cookies_sgx.txt \
-o annoucement_main.txt \
http://www.sgx.com/wps/portal/sgxweb/home/company_disclosure/company_announcements

for select in "AnnouncementByTimePeriod" "AnnouncementByIssuer" "AnnouncementBySecurity"
do
    echo "Proccessing: $select"
    curl \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Encoding: gzip, deflate' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H 'Connection: keep-alive' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'Host: www.sgx.com' \
    -H 'Referer: http://www.sgx.com/wps/portal/sgxweb/home/company_disclosure/company_announcements' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:49.0) Gecko/20100101 Firefox/49.0' \
    -H 'X-Requested-With: XMLHttpRequest' \
    -c cookies_sgx.txt \
    -b cookies_sgx.txt \
    "http://www.sgx.com/proxy/SgxDominoHttpProxy?timeout=14400&dominoHost=http%3A%2F%2Finfofeed.sgx.com%2FApps%3FA%3DCOW_CorpAnnouncement_Content%26B%3D${select}%26C_T%3D-1" | gzip -d > ${select}.txt
    
    grep -Eo "\"items\":.*$" ${select}.txt | sed "s#\"items\":#var ${select}s = #" | sed "s#,{}]}#]#" > ${select}_new.js
    if [ -s "${select}_new.js" ] ; then
        mv ${select}_new.js ${select}.js
    fi
done