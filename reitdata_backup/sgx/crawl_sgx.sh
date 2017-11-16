#cd /d/werner/project-01/sgx
CMD_DEBUG_OPT=0
CMD_HELP_OPT=0

function print_help {
cat <<_EOF_
Usage: `basename $0` [OPTIONS]
	-d 		    Enabled debug
	-h			Print this help message.
_EOF_
}

while getopts "dh" OPTION
do
  case $OPTION in
  	d) CMD_DEBUG_OPT=1 ;;
  	*) CMD_HELP_OPT=1 ;;
  esac
done

current_basename=`basename $PWD`
if [ "$CMD_DEBUG_OPT" = "1" ] ;
then
    echo $current_basename
fi
if [ "$current_basename" != "sgx" ] ; then
    cd public_html/sgx
    if [ "$CMD_DEBUG_OPT" = "1" ] ;
    then
        echo $PWD
    fi
fi

echo "Executing time: $(date)"

#stocks=(\
#"KRISENERGY%20LTD." "SINGAPORE%20POST%20LIMITED" "SINGAPORE%20PRESS%20HOLDINGS%20LIMITED" "KEPPEL%20CORPORATION%20LIMITED" "NOBLE%20GROUP%20LIMITED" \
#"SIA%20ENGINEERING%20COMPANY%20LIMITED" "ROTARY%20ENGINEERING%20LIMITED." "GENTING%20SINGAPORE%20PLC" "SINGAPORE%20TELECOMMUNICATIONS%20LIMITED" "SILVERLAKE%20AXIS%20LTD" \
#"STARHUB%20LTD." "NAM%20CHEONG%20LIMITED" "EZION%20HOLDINGS%20LIMITED" "NICO%20STEEL%20HOLDINGS%20LIMITED" \
#)
stocks=(\
"ACCORDIA GOLF TRUST MANAGEMENT PTE. LTD." \
"AEM HOLDINGS LTD." \
"AIMS AMP CAPITAL INDUSTRIAL REIT MANAGEMENT LIMITED" \
"ARA ASSET MANAGEMENT (FORTUNE) LIMITED" \
"ARA TRUST MANAGEMENT (SUNTEC) LIMITED" \
"ARA-CWT TRUST MANAGEMENT (CACHE) LIMITED" \
"ASCENDAS FUNDS MANAGEMENT (S) LIMITED" \
"ASCENDAS HOSPITALITY FUND MANAGEMENT PTE. LTD." \
"ASCENDAS PROPERTY FUND TRUSTEE PTE. LTD." \
"ASCOTT RESIDENCE TRUST MANAGEMENT LIMITED" \
"AUSNET SERVICES LTD" \
"BHG RETAIL TRUST MANAGEMENT PTE. LTD." \
"BOWSPRIT CAPITAL CORPORATION LIMITED" \
"CAMBRIDGE INDUSTRIAL TRUST MANAGEMENT LIMITED" \
"CAPITALAND COMMERCIAL TRUST MANAGEMENT LIMITED" \
"CAPITALAND MALL TRUST MANAGEMENT LIMITED" \
"CAPITALAND RETAIL CHINA TRUST MANAGEMENT LIMITED" \
"COMFORTDELGRO CORPORATION LIMITED" \
"CROESUS RETAIL ASSET MANAGEMENT PTE. LTD." \
"DBS GROUP HOLDINGS LTD" \
"EZION HOLDINGS LIMITED" \
"EZRA HOLDINGS LIMITED" \
"FEO HOSPITALITY ASSET MANAGEMENT PTE. LTD." \
"FRASERS CENTREPOINT ASSET MANAGEMENT (COMMERCIAL) LTD." \
"FRASERS CENTREPOINT ASSET MANAGEMENT LTD." \
"FRASERS HOSPITALITY ASSET MANAGEMENT PTE. LTD." \
"FRASERS LOGISTICS & INDUSTRIAL ASSET MANAGEMENT PTE. LTD." \
"FSL TRUST MANAGEMENT PTE. LTD." \
"GENTING SINGAPORE PLC" \
"GLOBAL LOGISTIC PROPERTIES LIMITED" \
"GUOCOLAND LIMITED" \
"HONG LEONG FINANCE LIMITED" \
"HUTCHISON PORT HOLDINGS MANAGEMENT PTE. LIMITED" \
"INDIABULLS PROPERTY MANAGEMENT TRUSTEE PTE. LTD." \
"IREIT GLOBAL GROUP PTE. LTD." \
"JAPAN RESIDENTIAL ASSETS MANAGER LIMITED" \
"KEPPEL CORPORATION LIMITED" \
"KEPPEL DC REIT MANAGEMENT PTE. LTD." \
"KEPPEL INFRASTRUCTURE FUND MANAGEMENT PTE LTD" \
"KEPPEL REIT MANAGEMENT LIMITED" \
"KEPPEL TELECOMMUNICATIONS & TRANSPORTATION LTD" \
"KRISENERGY LTD." \
"KSH HOLDINGS LIMITED" \
"LMIRT MANAGEMENT LTD." \
"M&C REIT MANAGEMENT LIMITED" \
"M1 LIMITED" \
"MACQUARIE APTT MANAGEMENT PTE. LIMITED" \
"MANULIFE US REAL ESTATE MANAGEMENT PTE. LTD." \
"MAPLETREE COMMERCIAL TRUST MANAGEMENT LTD." \
"MAPLETREE GREATER CHINA COMMERCIAL TRUST MANAGEMENT LTD." \
"MAPLETREE INDUSTRIAL TRUST MANAGEMENT LTD." \
"MAPLETREE LOGISTICS TRUST MANAGEMENT LTD." \
"NAM CHEONG LIMITED" \
"NICO STEEL HOLDINGS LIMITED" \
"NOBLE GROUP LIMITED" \
"OUE COMMERCIAL REIT MANAGEMENT PTE. LTD." \
"OUE HOSPITALITY REIT MANAGEMENT PTE. LTD." \
"OVERSEA-CHINESE BANKING CORPORATION LIMITED" \
"PARKWAY TRUST MANAGEMENT LIMITED" \
"RELIGARE HEALTH TRUST TRUSTEE MANAGER PTE. LTD." \
"RICKMERS TRUST MANAGEMENT PTE. LTD." \
"ROTARY ENGINEERING LIMITED." \
"SABANA REAL ESTATE INVESTMENT MANAGEMENT PTE. LTD." \
"SATS LTD." \
"SB REIT MANAGEMENT PTE. LTD." \
"SBS TRANSIT LTD" \
"SEMBCORP MARINE LTD" \
"SIA ENGINEERING COMPANY LIMITED" \
"SILVERLAKE AXIS LTD" \
"SINGAPORE EXCHANGE SECURITIES TRADING LIMITED" \
"SINGAPORE POST LIMITED" \
"SINGAPORE PRESS HOLDINGS LIMITED" \
"SINGAPORE TECHNOLOGIES ENGINEERING LTD" \
"SINGAPORE TELECOMMUNICATIONS LIMITED" \
"SPH REIT MANAGEMENT PTE. LTD." \
"STARHUB LTD." \
"UNITED OVERSEAS BANK LIMITED" \
"VIVA INDUSTRIAL TRUST MANAGEMENT PTE. LTD." \
"WHEELOCK PROPERTIES (SINGAPORE) LIMITED" \
"YTL STARHILL GLOBAL REIT MANAGEMENT LIMITED" \
)
#stocks=(\
#"KRISENERGY LTD." \
#)

stocks_alias=("krisenergy" "singpost" "sph" "keppel_corp" "noble" "sia_engg" "rotary" "genting" "singtel" "silver" "starhub" "nam_cheong" "ezion" "nico_steel")
gmail_user=werner73test@gmail.com
gmail_password=Password999!@#$
recipients=("<wernergiam73@gmail.com>" "<ongchiewping72@gmail.com>" "<ongsiewsiew78@gmail.com>" "<weetuefatt@gmail.com>" "<kktan8@outlook.com>" "<tankangseng@gmail.com>")
today_date=`date +%d_%m_%Y`
fourteen_days_ago=`date +%d_%m_%Y -d '-14 day'`
mailx_exist=`which mailx`
gfind_exist=`which gfind`
debug=true

#clean up error file created 14 days ago
rm -f error_*_${fourteen_days_ago}.txt

#clean up mail when transition from 1 day to the other
if [ -z "$gfind_exist" ] ;
then
    find -name 'mail_*.txt' -daystart -mtime 1 -exec rm \{\} \;
else 
    gfind 'mail_*.txt' -daystart -mtime 1 -exec rm \{\} \;
fi

curl \
--header "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:49.0) Gecko/20100101 Firefox/49.0" \
--connect-timeout 10 \
-c cookies_sgx.txt \
-o annoucement_main.txt \
http://www.sgx.com/wps/portal/sgxweb/home/company_disclosure/company_announcements

#Last 3 mths
#curl \
#-X POST \
#-H 'Host: www.sgx.com' \

#-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:49.0) Gecko/20100101 Firefox/49.0' \
#-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
#-H 'Accept-Language: en-US,en;q=0.5' \
#-H 'Content-Type: application/x-www-form-urlencoded' \
#-H 'X-Requested-With: XMLHttpRequest' \
#-H 'Referer: http://www.sgx.com/wps/portal/sgxweb/home/company_disclosure/company_announcements' \
#-H 'Connection: keep-alive' \
#-c cookies_sgx.txt \
#-b cookies_sgx.txt \
#-o 3mth_krisenergy.txt \
#http://www.sgx.com/proxy/SgxDominoHttpProxy?dominoHost=http%3A%2F%2Finfofeed.sgx.com%2FApps%3FA%3DCOW_CorpAnnouncement_Content%26B%3DAnnouncementLast3MonthsSecurity%26R_C%3DN_A%7EN_A%7EN_A%7EKRISENERGY%20LTD.%26C_T%3D20

for ((i=0; i<${#stocks[*]}; i++))
do
    tmp_stock=${stocks[i]}
    tmp_stock_filename=${stocks[i]}
    tmp_stock=`echo $tmp_stock | sed -f url_escape.sed`
    tmp_stock_filename=`echo $tmp_stock_filename | sed -r -e 's:[ \.\(\)&]:_:g'`
    if [ "$CMD_DEBUG_OPT" = "1" ] ;
    then
        echo "Processing ${tmp_stock_filename}: ${tmp_stock}"
    fi
    rm -f "today_${tmp_stock_filename}.txt"
    #today
    #when no data: {}&&{"SHARES":123, "items":[ No Document Found {}]}
    #when there is data:
    #curl \
    #-X POST \
    #-H 'Host: www.sgx.com' \
    #-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:49.0) Gecko/20100101 Firefox/49.0' \
    #-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    #-H 'Accept-Language: en-US,en;q=0.5' \
    #-H 'Content-Type: application/x-www-form-urlencoded' \
    #-H 'X-Requested-With: XMLHttpRequest' \
    #-H 'Referer: http://www.sgx.com/wps/portal/sgxweb/home/company_disclosure/company_announcements' \
    #-H 'Connection: keep-alive' \
    #-c cookies_sgx.txt \
    #-b cookies_sgx.txt \
    #"http://www.sgx.com/proxy/SgxDominoHttpProxy?dominoHost=http%3A%2F%2Finfofeed.sgx.com%2FApps%3FA%3DCOW_CorpAnnouncement_Content%26B%3DAnnouncementTodaySecurity%26R_C%3DN_A%7EN_A%7EN_A%7E${stocks[i]}%26C_T%3D20" > today_${stocks_alias[i]}.txt

    curl \
    --connect-timeout 10 \
    -X POST \
    -H 'Host: www.sgx.com' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:49.0) Gecko/20100101 Firefox/49.0' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'X-Requested-With: XMLHttpRequest' \
    -H 'Referer: http://www.sgx.com/wps/portal/sgxweb/home/company_disclosure/company_announcements' \
    -H 'Connection: keep-alive' \
    -c cookies_sgx.txt \
    -b cookies_sgx.txt \
    "http://www.sgx.com/proxy/SgxDominoHttpProxy?dominoHost=http%3A%2F%2Finfofeed.sgx.com%2FApps%3FA%3DCOW_CorpAnnouncement_Content%26B%3DAnnouncementToday%26R_C%3D${tmp_stock}%26C_T%3D20" > today_${tmp_stock_filename}.txt
    
    no_document_found=`grep -Eo 'No Document Found' today_${tmp_stock_filename}.txt`
    items=`grep -Eo 'items' today_${tmp_stock_filename}.txt`
    #echo $no_document_found
    
    #cannot find item server error
    if [ ${#items} -eq "0" ] ;
    then
        if [ ! -e "error_${tmp_stock_filename}_${today_date}.txt" ] ;
        then
            json_data=`cat today_${tmp_stock_filename}.txt`
            echo -e "From: ${gmail_user}\nTo: <wernergiam73@gmail.com>\nSubject: Announcement ${tmp_stock_filename} ${today_date} error\n${json_data}" > "error_${tmp_stock_filename}_${today_date}.txt"
            if [ -z "$mailx_exist" ] ;
            then
                curl --connect-timeout 10 --url "smtps://smtp.gmail.com:465" --ssl-reqd --mail-from "${gmail_user}" --mail-rcpt "<wernergiam73@gmail.com>" --user "${gmail_user}:${gmail_password}" --insecure --upload-file "error_${tmp_stock_filename}_${today_date}.txt" -v
            else
                cat "error_${tmp_stock_filename}_${today_date}.txt" | mailx -s "Subject: Announcement ${tmp_stock_filename} ${today_date} error" wernergiam73@gmail.com
            fi
        fi
        exit 1
    fi
    
    #found something
    if [ ${#no_document_found} -eq "0" ] ;
    then
        #json_data=`grep -Eo '"items":\[.*\]' today_${tmp_stock_filename}.txt | grep -Eo '\[.*\]' | jq '.[]'`
        json_data=`grep -Eo '"items":\[.*\]' today_${tmp_stock_filename}.txt | sed -e 's/"items"://g'`
        if [ "$CMD_DEBUG_OPT" = "1" ] ;
        then
            echo "json_data: $json_data"
        fi
        json_data=`curl --connect-timeout 10 http://jsonprettyprint.com/json-pretty-printer.php --data-urlencode "json_data=${json_data}" | sed -n --expression="/<pre>/, /<\/pre>/ p" | sed -f html.sed`
        if [ "$CMD_DEBUG_OPT" = "1" ] ;
        then
            echo "json_data: $json_data"
        fi
        now_count=`echo ${json_data} | grep -Eo 'key' | wc -l`
        before_count=`grep -Eo 'key' mail_${tmp_stock_filename}.txt | wc -l`
        if [ "$CMD_DEBUG_OPT" = "1" ] ;
        then
            echo "now: $now_count before: $before_count"
        fi
        if [[ ! "$now_count" -eq "$before_count" ]] && [[ "$now_count" -gt "0" ]] ;
        then
            rm -f "mail_${tmp_stock_filename}.txt"
            for ((j=0; j<${#recipients[*]}; j++))
            do
                echo -e "From: ${gmail_user}\nTo: ${recipients[j]}\nSubject: Announcement ${tmp_stock_filename} ${today_date}\n${json_data}" | \
                sed -r -e 's#"key": "([A-Za-z0-9&=]+)"#"key": "http://infopub.sgx.com/Apps?A=COW_CorpAnnouncement_Content\&B=AnnouncementToday\&F=\1"#g' > "mail_${tmp_stock_filename}.txt"
                if [ -z "$mailx_exist" ] ;
                then
                    curl --connect-timeout 10 --url "smtps://smtp.gmail.com:465" --ssl-reqd --mail-from "${gmail_user}" --mail-rcpt "${recipients[j]}" --user "${gmail_user}:${gmail_password}" --insecure --upload-file "mail_${tmp_stock_filename}.txt"
                else
                    cat "mail_${tmp_stock_filename}.txt" | mailx -s "Subject: Announcement ${tmp_stock_filename} ${today_date}" "${recipients[j]}"
                fi    
            done
        fi
    fi
done