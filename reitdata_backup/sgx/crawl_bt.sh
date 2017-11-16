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
BT_CURRENT="bt_current.txt"
BT_PREVIOUS="bt_previous.txt"
BT="bt.txt"
gmail_user=werner73test@gmail.com
gmail_password=Password999!@#$
today_date=`date +%d_%m_%Y`

if [ -s "$BT_CURRENT" ] ; then
    mv "$BT_CURRENT" "$BT_PREVIOUS"
fi

touch "$BT_CURRENT"
curl www.businesstimes.com.sg > "$BT"

grep -E 'span +class="headline"' "$BT" > "$BT_CURRENT"
DIFFERENCE=`diff -u "$BT_PREVIOUS" "$BT_CURRENT" | grep -E '^\+'`

if [ "${#DIFFERENCE}" -gt 0 ] ; then
    rm -f "mail_bt.txt"
    for ((j=0; j<${#recipients[*]}; j++))
    do
        echo -e "From: ${gmail_user}\nTo: ${recipients[j]}\nSubject: Business Time ${today_date}\n${DIFFERENCE}" | \
        sed -r -e 's|href="|href="http://www.businesstimes.com.sg|g' > "mail_bt.txt"
        if [ -z "$mailx_exist" ] ;
        then
            curl --connect-timeout 10 --url "smtps://smtp.gmail.com:465" --ssl-reqd --mail-from "${gmail_user}" --mail-rcpt "${recipients[j]}" --user "${gmail_user}:${gmail_password}" --insecure --upload-file "mail_bt.txt"
        else
            cat "mail_bt.txt" | mailx -s "Subject: Business Time ${today_date}" "${recipients[j]}"
        fi    
    done
fi
