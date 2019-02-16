#!/bin/sh

#
# Generated onFri Feb 15 16:41:52 PST 2019# Start of user configurable variables
#
LANG=C
export LANG

# SSO username and password
read -p 'SSO User Name:' SSO_USERNAME
read -sp 'SSO Password:' SSO_PASSWORD


# Path to wget command
WGET=/usr/bin/wget
# Location of cookie file
COOKIE_FILE=/tmp/$$.cookies

# Log directory and file
LOGDIR=.
LOGFILE=$LOGDIR/wgetlog-`date +%m-%d-%y-%H:%M`.log
# Output directory and file
OUTPUT_DIR=.
#
# End of user configurable variable
#

if [ "$SSO_PASSWORD " = " " ]
then
 echo "Please edit script and set SSO_PASSWORD"
 exit
fi

SSO_RESPONSE=`$WGET --user-agent="Mozilla/5.0"  --no-check-certificate https://edelivery.oracle.com/osdc/faces/SoftwareDelivery -O- 2>&1|grep Location`

# Extract request parameters for SSO
SSO_TOKEN=`echo $SSO_RESPONSE| cut -d '=' -f 2|cut -d ' ' -f 1`
SSO_SERVER=`echo $SSO_RESPONSE| cut -d ' ' -f 2|cut -d '/' -f 1,2,3`
SSO_AUTH_URL=/sso/auth
AUTH_DATA="ssousername=$SSO_USERNAME&password=$SSO_PASSWORD&site2pstoretoken=$SSO_TOKEN"

# The following command to authenticate uses HTTPS. This will work only if the wget in the environment
# where this script will be executed was compiled with OpenSSL. Remove the --secure-protocol option
# if wget was not compiled with OpenSSL
# Depending on the preference, the other options are --secure-protocol= auto|SSLv2|SSLv3|TLSv1
$WGET --user-agent="Mozilla/5.0" --secure-protocol=auto --post-data $AUTH_DATA --save-cookies=$COOKIE_FILE --keep-session-cookies $SSO_SERVER$SSO_AUTH_URL -O sso.out >> $LOGFILE 2>&1

rm -f sso.out


$WGET --user-agent="Mozilla/5.0"  --no-check-certificate  --load-cookies=$COOKIE_FILE --save-cookies=$COOKIE_FILE --keep-session-cookies "https://edelivery.oracle.com/osdc/softwareDownload?fileName=V35071-01.zip&token=NXAzVlpCSDFvcDJCOGR1U2NoTnZhQSE6OiFmaWxlSWQ9NTUyMjM4NjcmZmlsZVNldENpZD04MTMxNTMmcmVsZWFzZUNpZHM9ODMyMzYmcGxhdGZvcm1DaWRzPTM1JmRvd25sb2FkVHlwZT05NTc2MSZhZ3JlZW1lbnRJZD01MjI1NTI3JmVtYWlsQWRkcmVzcz1jYXJseS5iZWFuQHNwaGVyZWNvLmNvbSZ1c2VyTmFtZT1FUEQtQ0FSTFkuQkVBTkBTUEhFUkVDTy5DT00maXBBZGRyZXNzPTIzLjk2LjI1LjE3MSZ1c2VyQWdlbnQ9TW96aWxsYS81LjAgKFdpbmRvd3MgTlQgMTAuMDsgV2luNjQ7IHg2NCkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzcyLjAuMzYyNi4xMDkgU2FmYXJpLzUzNy4zNiZjb3VudHJ5Q29kZT1VUw" -O $OUTPUT_DIR/V35071-01.zip>> $LOGFILE 2>&1 

