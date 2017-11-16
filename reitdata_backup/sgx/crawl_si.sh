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

mailx_exist=`which mailx`
echo "Executing time: $(date)"
recipients=("<wernergiam73@gmail.com>" "<ongsiewsiew78@gmail.com>" "<weetuefatt@gmail.com>" "<kktan8@outlook.com>" "<tankangseng@gmail.com>")
#recipients=("<wernergiam73@gmail.com>")
BT_CURRENT="si_current.txt"
BT_PREVIOUS="si_previous.txt"
BT="si.txt"
gmail_user=werner73test@gmail.com
gmail_password=Password999!@#$
today_date=`date +%d_%m_%Y`
si_date=`date +%Y%m%d`

if [ -s "$BT_CURRENT" ] ; then
    mv "$BT_CURRENT" "$BT_PREVIOUS"
fi

touch "$BT_CURRENT"
curl "http://www.shareinvestor.com/news/news_list_f.html?type=regional_news_all&page=1&date=${si_date}&market=sgx" --compress > "$BT"

grep -E 'div +class="sic_more"' "$BT" > "$BT_CURRENT"
DIFFERENCE=`diff -u "$BT_PREVIOUS" "$BT_CURRENT" | grep -E '^\+ '`

if [ "${#DIFFERENCE}" -gt 0 ] ; then
    rm -f "mail_si.txt"
    for ((j=0; j<${#recipients[*]}; j++))
    do
        echo -e "From: ${gmail_user}\nTo: ${recipients[j]}\nContent-Type: text/html\nSubject: Share Investor ${today_date}\n<html><body>${DIFFERENCE}</body></html>" | \
        sed -r -e 's|href="|href="http://www.shareinvestor.com|g' | \
        sed -r -e 's|\+              <div class="sic_more">More</div>|<br><br>|g' > "mail_si.txt"
        if [ -z "$mailx_exist" ] ;
        then
            curl --connect-timeout 10 --url "smtps://smtp.gmail.com:465" --ssl-reqd --mail-from "${gmail_user}" --mail-rcpt "${recipients[j]}" --user "${gmail_user}:${gmail_password}" --insecure --upload-file "mail_si.txt"
        else
            #cat "mail_si.txt" | mailx -s "Subject: Share Investor ${today_date}" "${recipients[j]}"
            cat "mail_si.txt" | /usr/sbin/sendmail -t
        fi    
    done
fi
