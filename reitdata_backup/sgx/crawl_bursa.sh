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

stocks=(\
"ALLIANCE FINANCIAL GROUP BERHAD" \
"SUNWAY REAL ESTATE INVESTMENT TRUST" \
"IGB REAL ESTATE INVESTMENT TRUST" \
)

stocks_aliases=("2488" "5176" "5227")
gmail_user=werner73test@gmail.com
gmail_password=Password999!@#$
recipients=("<wernergiam73@gmail.com>" "<ongchiewping72@gmail.com>" "<ongsiewsiew78@gmail.com>")
today_date=`date +%d_%m_%Y`
fourteen_days_ago=`date +%d_%m_%Y -d '-14 day'`
mailx_exist=`which mailx`
gfind_exist=`which gfind`
cur_date=`date +%d`
cur_month=`date +%m`
cur_year=`date +%Y`
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

for ((i=0; i<${#stocks[*]}; i++))
do
    tmp_stock=${stocks[i]}
    tmp_stock_filename=${stocks[i]}
    tmp_stock_alias=${stocks_aliases[i]}
    tmp_stock=`echo $tmp_stock | sed -f url_escape.sed`
    tmp_stock_filename=`echo ${tmp_stock_filename}_${tmp_stock_alias} | sed -r -e 's:[ \.\(\)&]:_:g'`
    if [ "$CMD_DEBUG_OPT" = "1" ] ;
    then
        echo "Processing ${tmp_stock_filename}: ${tmp_stock}"
    fi
    rm -f "today_${tmp_stock_filename}.txt"
    #today
    #when no data: There are no announcements
    #when there is data:
    curl \
    --compressed \
    -H "Host: ws.bursamalaysia.com" \
    -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:51.0) Gecko/20100101 Firefox/51.0" \
    -H "Accept: */*" -H "Accept-Language: en-US,en;q=0.5" \
    -H "Referer: http://www.bursamalaysia.com/market/listed-companies/company-announcements/" \
    "http://ws.bursamalaysia.com/market/listed-companies/company-announcements/announcements_listing_f.html?_=1486349263149&callback=jQuery16205926770030792762_1486349253708&page_category=company&category=all&sub_category=all&all_gm=&alphabetical=All&board=&sector=&date_from=${cur_date}"%"2F${cur_month}"%"2F${cur_year}&date_to=${cur_date}"%"2F${cur_month}"%"2F${cur_year}&company=${tmp_stock_alias}&page=&testing=" > today_${tmp_stock_filename}.txt

    no_document_found=`grep -Eo 'There are no announcements' today_${tmp_stock_filename}.txt`
    items=`grep -Eo '\/market\/listed\-companies\/company\-announcements' today_${tmp_stock_filename}.txt`
    #echo $no_document_found
    
    #cannot find item server error
    if [[ ${#items} -eq "0" ]] && [[ ${#no_document_found} -eq "0" ]] ;
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
        json_data=`grep -Eo '"html":.*' today_${tmp_stock_filename}.txt | sed -r -e 's/"html":"|","pagination":.*[})]+$//g' | sed -f unicode.sed | sed -r -e 's/[\]"/"/g'`
        if [ "$CMD_DEBUG_OPT" = "1" ] ;
        then
            echo "json_data: $json_data"
        fi
        #json_data=`curl --connect-timeout 10 http://jsonprettyprint.com/json-pretty-printer.php --data-urlencode "json_data=${json_data}" | sed -n --expression="/<pre>/, /<\/pre>/ p" | sed -f html.sed`
        #if [ "$CMD_DEBUG_OPT" = "1" ] ;
        #then
        #    echo "json_data: $json_data"
        #fi
        now_count=`echo ${json_data} | grep -Eo 'company\-announcements' | wc -l`
        before_count=`grep -Eo 'company\-announcements' mail_${tmp_stock_filename}.txt | wc -l`
        if [ "$CMD_DEBUG_OPT" = "1" ] ;
        then
            echo "now: $now_count before: $before_count"
        fi
        if [ ! "$now_count" -eq "$before_count" ] ;
        then
            rm -f "mail_${tmp_stock_filename}.txt"
            for ((j=0; j<${#recipients[*]}; j++))
            do
                echo -e "From: ${gmail_user}\nTo: ${recipients[j]}\nSubject: Announcement ${tmp_stock_filename} ${today_date}\n${json_data}" | \
                sed -r -e 's|href="|href="http://www.bursamalaysia.com|g' > "mail_${tmp_stock_filename}.txt"
                if [ -z "$mailx_exist" ] ;
                then
                    curl --connect-timeout 10 --url "smtps://smtp.gmail.com:465" --ssl-reqd --mail-from "${gmail_user}" --mail-rcpt "${recipients[j]}" --user "${gmail_user}:${gmail_password}" --insecure --upload-file "mail_${tmp_stock_filename}.txt"
                    #echo ""
                else
                    cat "mail_${tmp_stock_filename}.txt" | mailx -s "Subject: Announcement ${tmp_stock_filename} ${today_date}" "${recipients[j]}"
                fi    
            done
        fi
    fi
done