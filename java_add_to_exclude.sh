#!/usr/bin/env bash

GREP=`which grep`
if [ -z "$GREP" ];then
    echo -e "\n \033[31mWARNING\nIt seems you don't have grep ?! O_o\n"
    exit 2
fi
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    exception_sites="$HOME/.java/deployment/security/exception.sites"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    exception_sites="/Users/$USER/Library/Application Support/Oracle/Java/Deployment/security/exception.sites"
else
    echo "\nERROR\nIt seems your OS is different than Linux/MacOS !!!\n"
    exit 2
fi




if [ "$#" -ne 1 ];then
    echo -e "\nIllegal number of parameters\n"
    echo -e "USAGE:\n \033[31m$0 'IP that you want to add'\n"
    exit 2
else
    if [ -n "$1" ];then
        echo "$1" | egrep "^([0-9]+.){3}[0-9]+$" > /dev/null
        if [ $? -eq 0 ];then
            ip="$1"
        else
            echo -e "\n \033[31mIt seems you provided 'sometning', but not IPv4 address! \n"
            exit 2
        fi
    else
        echo -e "\n \033[31mPlease provide IPv4 address! \n"
        exit 2
    fi
fi


if [ -f "$exception_sites" ];then
  if [ -r "$exception_sites" ] && [ -w "$exception_sites" ];then
    grep "$ip" "$exception_sites"
    if [ $? -eq 0 ];then
        echo -e "\n \033[31m Hey, this address: $ip already exists in the list!\n\033[0m"
        echo -e "If you are experiencing some troubles with JAVA-security exclude list, please try to customize your environment via JAVA security settings.\n"
        exit 2
    else
        echo "https://$ip/" >> "$exception_sites" && echo "http://$ip/" >> "$exception_sites"
        if [ $? -eq 0 ];then
          echo -e "\n \033[32m * JAVA_exception list was updated \n"
          exit 0
        else
          echo -e "\n \033[31m EROOR\nJAVA_exception list was NOT updated!\nPlease check if file exists and has corresponding permissions.\n"
          exit 2
        fi
    fi
  else
      echo  -e "\nCan't READ/WRITE file:\n\033[31m'$exception_sites'"
  fi
else
  echo -e "\nCan't find file:\n\033[31m'$exception_sites'"
fi
