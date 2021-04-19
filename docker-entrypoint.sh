#!/bin/bash

[ $DEBUG ] && set -x 

# Declare file url , where should we get data. 

# And the file name.
file_name=$(echo ${file_url} | awk -F '/' '{print $NF}')

# Identify if the file exists.
wget --spider ${file_url}
if [[ $? != 0 ]];then 
    echo "Exiting! Verify that the download address is correct."
    exit 1
fi

# Declare file path , where should we store data.
file_path=${FILE_PATH}

# Identify if the dir exists.
if [[ ! -d ${file_path} ]];then
    echo "Exiting! Verify that the destination directory exists and is persisted."
    exit 1
fi

# Declare other download args , for wget.
download_args=${DOWNLOAD_ARGS}

# Declares whether to extract the file
extract_file=${EXTRACT_FILE:-true}

# Recognize the type of data. what we want is *.tgz *.tar.gz or *.zip
if [[ ${file_name} != *.tar.gz ]] && [[ ${file_name} != *.zip ]] && [[ ${file_name} != *.tgz ]];then
    echo "Exiting! What we want is *.tgz *.tar.gz or *.zip"
    exit 1
fi

# Processing zip file 
Process_zip(){
    wget -c -P ${file_path} ${download_args} ${file_url}
    if [[ $? != 0 ]];then
        echo "The download process has terminated unexpectedly. Please try restarting..."
        exit 1
    fi

    if [[ ${extract_file} == true ]];then
        unzip ${file_path}/${file_name} -d ${file_path}
        rm -rf ${file_path}/${file_name}
    fi
    touch ${file_path}/.datainited
}

# Processing tgz file 
Process_tgz(){
    wget -c -P ${file_path} ${download_args} ${file_url} 
    if [[ $? != 0 ]];then
        echo "The download process has terminated unexpectedly. Please try restarting..."
        exit 1
    fi

    if [[ ${extract_file} == true ]];then
        tar xf ${file_path}/${file_name} -C ${file_path}
        rm -rf ${file_path}/${file_name}
    fi
    touch ${file_path}/.datainited
}

# Main

if [[ ! -f ${file_path}/.datainited ]];then
    case ${file_name} in 
        *.zip) Process_zip
        ;;
        *) Process_tgz
        ;;
    esac
else
    echo "The data has already been initialized, this initialization is skipped..."
fi
