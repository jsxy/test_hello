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
	expect -c"
	spawn ssh ${src_user}@${src_ip}
	expect {
		\"*yes/no*\" {send \"yes\r\"; exp_continue}
		\"*yes/no*\" {send \"yes\r\"; exp_continue}
		\"*password*\" {send \"${src_pwd}\r\";}
	}
	send \"sed -n '/master.zeus.com/p' /etc/hosts\r\"
	send \"sed -i '/master.zeus.com/d' /etc/hosts\r\"
	send \"echo \'10.10.70.73  master.zeus.com\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.248 hc16\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.249 hc15\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.250 hc14\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.251 hc13\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.252 hc12\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.253 hc11\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.254 hc10\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.205 hc9\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.206 hc8\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.207 hc7\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.208 hc6\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.209 hc5\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.210 hc4\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.211 hc3\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.212 hc2\' >> /etc/hosts \r\"
	send \"echo \'10.10.77.213 hc1\' >> /etc/hosts \r\"
	send \"sed -n '/master.zeus.com/p' /etc/hosts\r\"
	send \"exit\r\"
	expect eof
	"
done
