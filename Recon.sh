#!/bin/bash

process_url() {
    local url="$1"
    local folder=$(echo "$url" | sed 's/\./-/g')
    touch $folder
    
   echo -e "HTTPX RESULTS\n\n\n" >> $folder
   httpx -u $url -sc -cl -random-agent -silent >> $folder </dev/null
   echo -e "\n\n\n" >> $folder
    
   echo -e "NAABU RESULTS\n\n\n" >> $folder
   naabu -host $url -p - -silent >> $folder </dev/null
   echo -e "\n\n\n" >> $folder
    
    echo -e "KATANA RESULTS\n\n\n" >> $folder
    katana -u "https://$url" -d 5 -kf -silent >> $folder </dev/null
    echo -e "\n\n\n" >> $folder
    
    

    echo -e "PARAMSPIDER RESULTS\n\n\n" >> $folder
    source ~/Tools/paramspider/ParamEnv/bin/activate
    paramspider -d $url </dev/null
    deactivate
    cat results/* >> $folder </dev/null
    rm -rf results/
    echo -e "\n\n\n" >> $folder
    
}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 url-or-file"
    exit 1
fi

input="$1"

if [ -f "$input" ]; then
    while IFS= read -r url; do
        process_url $url
        
    done < "$input"
    
else
    process_url "$input"
fi

