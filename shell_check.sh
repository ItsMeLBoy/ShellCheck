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
	printf "$red[ File not found! ]$white\n"
	exit
fi
echo ""

# function
function JavaGhostShellChk(){
	if [[ $(curl --user-agent "${UserAgent}" -sIXGET $url | grep -o "200") =~ "200" ]]; then
		check_os=$(curl --user-agent "${UserAgent}" -s "$url" --compressed | grep -o "Linux\|Ubuntu\|Windows\|CentOS")
		if [[ $check_os =~ "Linux" ]] || [[ $check_os =~ "Ubuntu" ]] || [[ $check_os =~ "Windows" ]] || [[ $check_os =~ "CentOS" ]]; then
			local shell_name=$(curl --user-agent "${UserAgent}" -s $url --compressed | grep -o "<title>.*" | cut -d ">" -f2 | cut -d "<" -f1)
			local shell_system=$(curl --user-agent "${UserAgent}" -s $url --compressed | grep -o "Linux.*\|Ubuntu.*\|Windows.*\|CentOS.*" | cut -d "<" -f1)
			local shell_Ips=$(dig +short $(echo $url | sed 's|https://www.||g;s|https://||g;s|http://||g' | cut -d "/" -f1,2,3 | sed "s|http://||g"))
			printf "$white[ $green%sLIVE%s$white ] $red-$white $url $red[$white Shell name $red:$green $shell_name $red]\n$white[$red+$white] Sys $red:$yellow $shell_system\n$white[$red+$white] IPs $red:$yellow $shell_Ips\n"
			echo $url >> live_shell.txt
    	elif [[ $(curl --user-agent "${UserAgent}" -s "$url" --compressed | grep -o '<input type="password"\|<input type=password') =~ "password" ]]; then
    		printf "$white[ $green%sLIVE%s$white ] $red-$white $url $red[$white Shell with password $red-$white cant show info $red]$white"
			echo $url >> live_shell.txt
    	else
    		printf "$white[ $green%sLIVE%s$white ] $red-$white $url\n$white[$red-$white] Information not showing $red[$white contact $red:${blue} https://fb.me/n00b.me $red]$white\n"
			echo $url >> live_shell.txt
    	fi
	else
		printf "$white[ $red%sDEAD%s$white ] $red-$white $url\n"
	fi
}

# multithread
(
	for url in $(cat $ask); do
		((thread=thread%1)); ((thread++==0)) && wait
		JavaGhostShellChk "$url" &
	done
	wait
)

printf "\n\n$white[$red+$white] Total live shell $red:$green  "$( < live_shell.txt wc -l)"\n"
# end
