#!/bin/bash
#可传入的参数

ERRORMESS="Usage: `basename $0` -f [first_hostip] -l [last_hostip]"

while getopts "f:l:"  arg  #选项后面的冒号表示该选项需要参数
do
	case $arg in
	f)
		first_hostip=$OPTARG ;;
	l)
		last_hostip=$OPTARG ;;
	\?)
		echo "Usage: args  [-f] [-l]"
		echo "-f means first_hostip"
		echo "-m means last_hostip"
		exit 1;;
	esac
done

#如果不传参数，退出不执行
if [[ ! ${first_hostip} ]]; then
	echo ${ERRORMESS}
	exit
fi

if [[ ! ${last_hostip} ]]; then
	echo ${ERRORMESS}
	exit
fi

#src_host="10.10.77."
src_user="root"
src_pwd="supconit"

#echo "修改host文件："
src_host=${first_hostip%.*}       #从右向左截取 第一个. 后的字符串
src_first=${first_hostip##*.}      #从左向右截取最后一个. 后的字符串
src_last=${last_hostip##*.}      #从左向右截取最后一个. 后的字符串
echo "host is ${src_host}"
echo "fisrtip is ${src_first}"
echo "lastip is ${src_last}"

for((i=${src_first};i<=${src_last};i++))
	do
	src_ip=${src_host}.$i
	echo "${src_ip}"
	expect -c"
		spawn ssh ${src_user}@${src_ip}
		expect \"password:\"
		send \"${src_pwd}\r\"
		send \"bash_pid=\`ps -ef | grep ./agent | grep ? | awk '{print \\\$2}'\`\r\"
		send \"kill -9 \\\${bash_pid}\r\"
		send \"cd /home/hc/zeus/agent\r\"
		send \"./agent.sh stop\r\"
		send \"cd /home/hc/zeus\r\"
		send \"rm -rf agent\r\"
		send \"rm -rf agent.tar.gz\r\"
		send \"exit\r\"
		expect eof
	"
	done
