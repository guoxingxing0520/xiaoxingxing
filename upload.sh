#!/bin/bash

echo `pwd`

if [[ $# -lt 1 ]];then
  echo "uploadFile2kcdn.sh filePath [fileName] [rewrite]"
  exit 0
fi

execDir=`pwd`
token="10772_f6ccb6f6d17a60ebbc912e8bf5a32a39"
filePath=$1
fileName=""
uploadFile=$filePath
allowRewrite=false

if [[ $# -ge 2 ]]; then
  fileName=$2
fi

if [[ $# -ge 3 ]];then
  allowRewrite=$3
fi

zipFileDir="/tmp/upload"

echo `ls $filePath`

if [[ ! -d $zipFileDir ]];then
  mkdir $zipFileDir
fi

echo "input: "
echo "filePath= $filePath"
echo "fileName= $fileName"

if [[ $fileName"x" == "x" ]]; then
  echo -e "\e[33mWARN!!!\e[0m 重复命名会覆盖kcdn上的文件"
  fileName=${filePath##*/}
fi


realFileName=${fileName##*/}
if [[ -d $filePath ]];then
  echo "filePath is dir, zip ing..."
  fileName=${fileName}.gz
  realFileName=${realFileName}.gz
  uploadFile=${zipFileDir}/${realFileName}
  echo "tar -czf $uploadFile $filePath"
  tar -czf $uploadFile $filePath
fi

echo "upload: "
echo "fileName= $fileName"
echo "uploadFileName= $uploadFile"


echo curl -F 'pid=facemagicserver' -F "allowRewrite=$allowRewrite" -F "filename=$fileName" -F "file=@$uploadFile"  https://kcdn.corp.kuaishou.com/api/kcdn/v1/service/npmUpload/single?token=$token
curl -F 'pid=facemagicserver' -F "allowRewrite=$allowRewrite" -F "filename=$fileName" -F "file=@$uploadFile"  https://kcdn.corp.kuaishou.com/api/kcdn/v1/service/npmUpload/single?token=$token
