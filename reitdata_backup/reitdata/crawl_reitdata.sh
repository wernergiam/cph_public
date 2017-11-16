#!/bin/bash

current_basename=`basename $PWD`
echo $current_basename
if [ "$current_basename" != "reitdata" ] ; then
    cd reitdata
    echo $PWD
fi

#1 crawl, 0 dun crawl
CMD_CRAWL_OPT=1
#1 clear the html, 0 dun clear
CMD_CLEAR_OPT=1

CMD_DEBUG_OPT=0
CMD_HELP_OPT=0
CMD_REIT_DATA=0
CMD_OTHER_DATA=0
CMD_SHIPPING_DATA=0

CMD_STI_DATA=0
CMD_AVIATION_DATA=0
CMD_TRANSPORT_DATA=0
CMD_TELCO_DATA=0
CMD_FINANCE_DATA=0
CMD_INFRA_DATA=0

function print_help {
cat <<_EOF_
Usage: `basename $0` [OPTIONS]
	-d 		    Enabled debug
	-c          Don't delete the html first
	-w          Don't crawl the web for data
	-r          Reit Data
	-o          Other Data
	-s          Shipping Data
	-i          STI Data
	-a          Aviation Data
	-t          Transport Data
	-e          Telco Data
	-f          Finance Data
	-n          Infra Data
	-h			Print this help message.
_EOF_
}

while getopts "dcwrosiatefnh" OPTION
do
  case $OPTION in
  	d) CMD_DEBUG_OPT=1 ;;
  	c) CMD_CLEAR_OPT=0 ;;
  	w) CMD_CRAWL_OPT=0 ;;
  	r) CMD_REIT_DATA=1 ;;
  	o) CMD_OTHER_DATA=1 ;;
  	s) CMD_SHIPPING_DATA=1 ;;
  	i) CMD_STI_DATA=1 ;;
  	a) CMD_AVIATION_DATA=1 ;;
  	t) CMD_TRANSPORT_DATA=1 ;;
  	e) CMD_TELCO_DATA=1 ;;
  	f) CMD_FINANCE_DATA=1 ;;
  	n) CMD_INFRA_DATA=1 ;;
  	*) CMD_HELP_OPT=1 ;;
  esac
done

if [ "$CMD_DEBUG_OPT" -eq 1 ] ; then
	set -x
fi

if [ "$CMD_HELP_OPT" -eq 1 ] ; then
	print_help
	exit 0
fi

first_time=1
json_data=""
crawl_option="r"
data_code_filename="reitdata_code.sh"
edittable_filename="reitdata_editable.txt"
output_js_filename="reit_data.js"
output_js_var_name="reitDatas"

if [ "${CMD_OTHER_DATA}" -eq 1 ] ; then
    crawl_option="o"
    data_code_filename="otherdata_code.sh"
    edittable_filename="otherdata_editable.txt"
    output_js_filename="other_data.js"
    output_js_var_name="otherDatas"
fi

if [ "${CMD_SHIPPING_DATA}" -eq 1 ] ; then
    crawl_option="s"
    data_code_filename="shippingdata_code.sh"
    edittable_filename="shippingdata_editable.txt"
    output_js_filename="shipping_data.js"
    output_js_var_name="shippingDatas"
fi

if [ "${CMD_STI_DATA}" -eq 1 ] ; then
    crawl_option="i"
    data_code_filename="stidata_code.sh"
    edittable_filename="stidata_editable.txt"
    output_js_filename="sti_data.js"
    output_js_var_name="stiDatas"
fi

if [ "${CMD_AVIATION_DATA}" -eq 1 ] ; then
    crawl_option="a"
    data_code_filename="aviationdata_code.sh"
    edittable_filename="aviationdata_editable.txt"
    output_js_filename="aviation_data.js"
    output_js_var_name="aviationDatas"
fi

if [ "${CMD_TRANSPORT_DATA}" -eq 1 ] ; then
    crawl_option="t"
    data_code_filename="transportdata_code.sh"
    edittable_filename="transportdata_editable.txt"
    output_js_filename="transport_data.js"
    output_js_var_name="transportDatas"
fi

if [ "${CMD_TELCO_DATA}" -eq 1 ] ; then
    crawl_option="e"
    data_code_filename="telcodata_code.sh"
    edittable_filename="telcodata_editable.txt"
    output_js_filename="telco_data.js"
    output_js_var_name="telcoDatas"
fi

if [ "${CMD_FINANCE_DATA}" -eq 1 ] ; then
    crawl_option="f"
    data_code_filename="financedata_code.sh"
    edittable_filename="financedata_editable.txt"
    output_js_filename="finance_data.js"
    output_js_var_name="financeDatas"
fi

if [ "${CMD_INFRA_DATA}" -eq 1 ] ; then
    crawl_option="n"
    data_code_filename="infradata_code.sh"
    edittable_filename="infradata_editable.txt"
    output_js_filename="infra_data.js"
    output_js_var_name="infraDatas"
fi

for reit_code in `cut -d '|' -f 2 ${data_code_filename}`
do
    prev_closed_currency=""
    echo $reit_code
    reit_name=`grep -E "$reit_code" ${data_code_filename} | cut -d '|' -f 1`
    echo $reit_name
    reit_filename="${reit_code}_${reit_name// /_}.html"
    echo $reit_filename
    #reit_url="https://sg.finance.yahoo.com/q?s=${reit_code}.SI"
    reit_url="https://sgx-premium.wealthmsi.com/sgx/company"

    if [ "$CMD_CLEAR_OPT" -eq 1 ] ; then
        rm data/$reit_filename
    fi

    if [ "$CMD_CRAWL_OPT" -eq 1 ] ; then
        #wget --no-check-certificate -a crawl_reitdata.log -w 5 -t 5 -O data/$reit_filename $reit_url
        #curl \
        #-X POST \
        #-d '{"id":"'${reit_code}'"}' \
        #-H 'Accept: application/json, text/javascript, */*; q=0.01' \
        #-H 'Accept-Encoding: gzip, deflate, br' \
        #-H 'Accept-Language: en-US,en;q=0.5' \
        #-H 'Cache-Control: no-cache' \
        #-H 'Connection: keep-alive' \
        #-H 'Content-Type: application/json' \
        #-H 'Cookie: _ga=GA1.1.1692100892.1474510770' \
        #-H 'Host: sgx-premium.wealthmsi.com' \
        #-H 'Referer: https://sgx-premium.wealthmsi.com/company-tearsheet.html?code=N21' \
        #-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:49.0) Gecko/20100101 Firefox/49.0' \
        #-H 'X-Requested-With: XMLHttpRequest' \
        #--insecure \
        #https://sgx-premium.wealthmsi.com/sgx/company | gzip -d > data/$reit_filename

        curl http://www.shareinvestor.com/fundamental/factsheet.html?counter=${reit_code}.SI > data/$reit_filename
    fi

    prev_closed=`grep -E 'sic_lastdone' data/$reit_filename | grep -Eo '[0-9]+.[0-9]+'`
    echo "Price: $prev_closed"
    prev_closed_currency=`grep -E 'sic_lastdone' data/$reit_filename | grep -Eo '\([A-Z]+\)' | sed -r 's:[\(|\)]+::g'`
    echo "Currency: $prev_closed_currency"

    reit_other_data=`grep -E "$reit_code" ${edittable_filename}`
    
    case $crawl_option in
  	r|o|s) current_period=""
    current_dpu=""
    current_ttl_dpu=""
    current_ttl_dpu_currency=""
    current_yield=""
    current_nav=""
    current_gearing=""
    current_asset_type=""

    if [ ! -z "$reit_other_data" ] ; then
        IFS='|' read var1 var2 current_period var3 current_dpu current_ttl_dpu current_ttl_dpu_currency current_yield current_nav current_gearing current_asset_type <<< "$reit_other_data"
        
        if [ ! -z "$prev_closed_currency" ] && [ ! "$prev_closed_currency" = "${current_ttl_dpu_currency}" ] ; then
            if [ ! -z "$current_ttl_dpu" ] && (( $(echo "$current_ttl_dpu 0" | awk '{if($1 > $2) print 1; else print 0}' ) )) ; then
                current_ttl_dpu=`curl "http://www.xe.com/currencyconverter/convert/?Amount=${current_ttl_dpu}&From=${current_ttl_dpu_currency}&To=${prev_closed_currency}" | grep -Eo 'uccResultAmount..[0-9]+.[0-9]+' | grep -Eo '[0-9]+.[0-9]+'`
                echo "Ttl DPU Price ${prev_closed_currency}: $current_ttl_dpu"
            fi
        fi

        json_current="{ "
        json_current="${json_current}\"code\": \"${reit_code}\", \"descr\": \"${reit_name}\", \"prevClosed\": \"${prev_closed}\""
        json_current="${json_current}, \"period\": \"${current_period}\", \"dpu\": \"${current_dpu}\", \"ttlDpu\": \"${current_ttl_dpu}\", \"yield\": \"${current_yield}\""
        json_current="${json_current}, \"nav\": \"${current_nav}\", \"gearing\": \"${current_gearing}\", \"assetType\": \"${current_asset_type}\""
        json_current="${json_current} }"

        if [ "$first_time" -eq 1 ] ; then
            json_data="${json_data}${json_current}"
            first_time=0
        else
            json_data="${json_data}\n, ${json_current}"
        fi
    fi
    ;;
  	i|a|t|e) current_period=""
    current_dpu=""
    current_ttl_dpu=""
    current_ttl_dpu_currency=""
    current_yield=""
    current_eps_cts=""
    current_pe=""
    current_div_breakdown=""

    if [ ! -z "$reit_other_data" ] ; then
        IFS='|' read var1 var2 current_period var3 current_dpu current_ttl_dpu current_ttl_dpu_currency current_yield current_eps_cts current_pe current_div_breakdown <<< "$reit_other_data"
        
        if [ ! -z "$prev_closed_currency" ] && [ ! "$prev_closed_currency" = "${current_ttl_dpu_currency}" ] ; then
            if [ ! -z "$current_ttl_dpu" ] && (( $(echo "$current_ttl_dpu 0" | awk '{if($1 > $2) print 1; else print 0}' ) )) ; then
                current_ttl_dpu=`curl "http://www.xe.com/currencyconverter/convert/?Amount=${current_ttl_dpu}&From=${current_ttl_dpu_currency}&To=${prev_closed_currency}" | grep -Eo 'uccResultAmount..[0-9]+.[0-9]+' | grep -Eo '[0-9]+.[0-9]+'`
                echo "Ttl DPU Price ${prev_closed_currency}: $current_ttl_dpu"
            fi
        fi

        json_current="{ "
        json_current="${json_current}\"code\": \"${reit_code}\", \"descr\": \"${reit_name}\", \"prevClosed\": \"${prev_closed}\""
        json_current="${json_current}, \"period\": \"${current_period}\", \"dpu\": \"${current_dpu}\", \"ttlDpu\": \"${current_ttl_dpu}\", \"yield\": \"${current_yield}\""
        json_current="${json_current}, \"epsCts\": \"${current_eps_cts}\", \"pe\": \"${current_pe}\", \"divBreakdown\": \"${current_div_breakdown}\""
        json_current="${json_current} }"

        if [ "$first_time" -eq 1 ] ; then
            json_data="${json_data}${json_current}"
            first_time=0
        else
            json_data="${json_data}\n, ${json_current}"
        fi
    fi
    ;;
    f) current_period=""
    current_nbv=""
    current_dpu=""
    current_ttl_dpu=""
    current_ttl_dpu_currency=""
    current_yield=""
    current_eps_cts=""
    current_pe=""
    current_div_breakdown=""
    period_b4=""
    nbv_b4=""
    eps_cts_b4=""
    pe_b4=""

    if [ ! -z "$reit_other_data" ] ; then
        IFS='|' read var1 var2 current_period var3 current_nbv current_dpu current_ttl_dpu current_ttl_dpu_currency current_yield current_eps_cts current_pe current_div_breakdown period_b4 nbv_b4 eps_cts_b4 pe_b4 <<< "$reit_other_data"
        
        if [ ! -z "$prev_closed_currency" ] && [ ! "$prev_closed_currency" = "${current_ttl_dpu_currency}" ] ; then
            if [ ! -z "$current_ttl_dpu" ] && (( $(echo "$current_ttl_dpu 0" | awk '{if($1 > $2) print 1; else print 0}' ) )) ; then
                current_ttl_dpu=`curl "http://www.xe.com/currencyconverter/convert/?Amount=${current_ttl_dpu}&From=${current_ttl_dpu_currency}&To=${prev_closed_currency}" | grep -Eo 'uccResultAmount..[0-9]+.[0-9]+' | grep -Eo '[0-9]+.[0-9]+'`
                echo "Ttl DPU Price ${prev_closed_currency}: $current_ttl_dpu"
            fi
        fi

        json_current="{ "
        json_current="${json_current}\"code\": \"${reit_code}\", \"descr\": \"${reit_name}\", \"prevClosed\": \"${prev_closed}\""
        json_current="${json_current}, \"period\": \"${current_period}\", \"dpu\": \"${current_dpu}\", \"ttlDpu\": \"${current_ttl_dpu}\", \"yield\": \"${current_yield}\""
        json_current="${json_current}, \"epsCts\": \"${current_eps_cts}\", \"pe\": \"${current_pe}\", \"divBreakdown\": \"${current_div_breakdown}\""
        json_current="${json_current}, \"periodBefore\": \"${period_b4}\", \"nbvBefore\": \"${nbv_b4}\", \"epsCtsBefore\": \"${eps_cts_b4}\""
        json_current="${json_current}, \"peBefore\": \"${pe_b4}\", \"nbv\": \"${current_nbv}\""
        json_current="${json_current} }"

        if [ "$first_time" -eq 1 ] ; then
            json_data="${json_data}${json_current}"
            first_time=0
        else
            json_data="${json_data}\n, ${json_current}"
        fi
    fi
    ;;
    n) current_period=""
    current_dpu=""
    current_ttl_dpu=""
    current_ttl_dpu_currency=""
    current_yield=""
    current_nav=""
    current_div_breakdown=""

    if [ ! -z "$reit_other_data" ] ; then
        IFS='|' read var1 var2 current_period var3 current_dpu current_ttl_dpu current_ttl_dpu_currency current_yield current_nav current_div_breakdown <<< "$reit_other_data"
        
        if [ ! -z "$prev_closed_currency" ] && [ ! "$prev_closed_currency" = "${current_ttl_dpu_currency}" ] ; then
            if [ ! -z "$current_ttl_dpu" ] && (( $(echo "$current_ttl_dpu 0" | awk '{if($1 > $2) print 1; else print 0}' ) )) ; then
                current_ttl_dpu=`curl "http://www.xe.com/currencyconverter/convert/?Amount=${current_ttl_dpu}&From=${current_ttl_dpu_currency}&To=${prev_closed_currency}" | grep -Eo 'uccResultAmount..[0-9]+.[0-9]+' | grep -Eo '[0-9]+.[0-9]+'`
                echo "Ttl DPU Price ${prev_closed_currency}: $current_ttl_dpu"
            fi
        fi

        json_current="{ "
        json_current="${json_current}\"code\": \"${reit_code}\", \"descr\": \"${reit_name}\", \"prevClosed\": \"${prev_closed}\""
        json_current="${json_current}, \"period\": \"${current_period}\", \"dpu\": \"${current_dpu}\", \"ttlDpu\": \"${current_ttl_dpu}\", \"yield\": \"${current_yield}\""
        json_current="${json_current}, \"nav\": \"${current_nav}\", \"divBreakdown\": \"${current_div_breakdown}\""
        json_current="${json_current} }"

        if [ "$first_time" -eq 1 ] ; then
            json_data="${json_data}${json_current}"
            first_time=0
        else
            json_data="${json_data}\n, ${json_current}"
        fi
    fi
    ;;
  	esac
done

echo -e "var ${output_js_var_name} = [\n${json_data}\n];" > ${output_js_filename}