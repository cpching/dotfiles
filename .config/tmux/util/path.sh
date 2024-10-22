#! /bin/bash
current_path="${1}"
current_path="$(echo ${current_path} | sed 's#'"$HOME"'#~#g')"

length=$(echo -n "$current_path" | wc -c)
if [[ $length -ge 20 ]]; then
    current_path=$(echo ${current_path} | awk -F'/' '{for(i=1; i<=NF; i++)\
                                                        if(i<=NF-2)  printf("%s/", substr($i, 1, 2));\
                                                        else if(i<=NF-1) printf("%s/",$i);\
                                                        else printf("%s",$i)}')
fi

echo ${current_path}
