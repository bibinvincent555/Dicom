#!/bin/sh


PORT=10389
SERVICE_NAME="apacheds"

is_service_running() {
    pgrep -f "$SERVICE_NAME" > /dev/null 2>&1
}


currentpath=$(pwd)
echo current_path: $currentpath
cd ..
APACHEDS_HOME=$(pwd)
echo APACHEDS_HOME: $APACHEDS_HOME/apacheds-2.0.0-M20
LDAP_SDK=$APACHEDS_HOME/unboundid-ldapsdk

cd $LDAP_SDK/tools
chmod +x ldapmodify ldapsearch ldapdelete


while /bin/netstat -an | /bin/grep \:10389 | /bin/grep LISTEN ; [ $? -ne 0 ]; do
    let TRIES-=1
    if [ $TRIES -gt 1 ]; then
            sleep $WAIT
    fi
done

$LDAP_SDK/tools/ldapdelete -h localhost -p 10389 -D "uid=admin,ou=system" -w secret --clientSideSubtreeDelete "ou=objectclasses,cn=dcm4chee-archive-ui,ou=schema"
$LDAP_SDK/tools/ldapdelete -h localhost -p 10389 -D "uid=admin,ou=system" -w secret --clientSideSubtreeDelete "ou=objectclasses,cn=dcm4chee-archive,ou=schema"
$LDAP_SDK/tools/ldapdelete -h localhost -p 10389 -D "uid=admin,ou=system" -w secret --clientSideSubtreeDelete "ou=objectclasses,cn=dcm4che,ou=schema"

cd $APACHEDS_HOME/apacheds-2.0.0-M20/bin
./apacheds.sh stop
sleep 5

while is_service_running; do
echo "Service is still running"
    sleep 2
done

echo "Service stopped successfully"

./apacheds.sh start

TRIES=30
WAIT=3

while /bin/netstat -an | /bin/grep \:10389 | /bin/grep LISTEN ; [ $? -ne 0 ]; do
    let TRIES-=1
    if [ $TRIES -gt 1 ]; then
            sleep $WAIT
    fi
done

sleep 9
$LDAP_SDK/tools/ldapdelete -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -f $currentpath/ldif/delete_list_dcm4che.ldif
$LDAP_SDK/tools/ldapdelete -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -f $currentpath/ldif/delete_list_dcm4chee-archive.ldif
$LDAP_SDK/tools/ldapdelete -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -f $currentpath/ldif/delete_list_dcm4chee-archive-ui.ldif




$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/apacheds/dcm4che.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/apacheds/dcm4chee-archive.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/apacheds/dcm4chee-archive-ui.ldif


cd $APACHEDS_HOME/apacheds-2.0.0-M20/bin

./apacheds.sh stop
sleep 5

while is_service_running; do
echo "Service is still running"
    sleep 2
done

echo "Service stopped successfully"

./apacheds.sh start

TRIES=30
WAIT=3

while /bin/netstat -an | /bin/grep \:10389 | /bin/grep LISTEN ; [ $? -ne 0 ]; do
    let TRIES-=1
    if [ $TRIES -gt 1 ]; then
            sleep $WAIT
    fi
done

sleep 9


$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.22.0/update-DCM4CHEE-5.22.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.22.0/update-dev-5.22.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.22.1/update-dev-5.22.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.22.2/update-dev-5.22.2.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.22.3/update-dev-5.22.3.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.22.4/update-AS_RECEIVED-5.22.4.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.22.4/update-DCM4CHEE-5.22.4.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.22.4/update-IOCM_REGULAR_USE-5.22.4.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.22.4/update-dev-5.22.4.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.22.4/update-storescp-5.22.4.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.22.5/update-dev-5.22.5.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.22.6/update-dev-5.22.6.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.0/update-AS_RECEIVED-5.23.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.0/update-DCM4CHEE-5.23.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.0/update-IOCM_REGULAR_USE-5.23.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.0/update-dev-5.23.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.0/update-storescp-5.23.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.1/update-AS_RECEIVED-5.23.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.1/update-DCM4CHEE-5.23.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.1/update-IOCM_REGULAR_USE-5.23.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.1/update-dev-5.23.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.1/update-storescp-5.23.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.2/update-dev-5.23.2.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.2/update-stowrsd-5.23.2.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.3/update-AS_RECEIVED-5.23.3.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.3/update-DCM4CHEE-5.23.3.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.3/update-IOCM_REGULAR_USE-5.23.3.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.3/update-dev-5.23.3.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.23.3/update-storescp-5.23.3.ldif




$LDAP_SDK/tools/ldapdelete -h localhost -p 10389 -D "uid=admin,ou=system" -w secret --clientSideSubtreeDelete "dcmuiConfigName=default,dicomDeviceName=dcm4chee-arc,cn=Devices,cn=DICOM Configuration,dc=dcm4che,dc=org"




$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/ldif/default-ui-config_5.24.ldif




$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.24.0/update-AS_RECEIVED-5.24.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.24.0/update-DCM4CHEE-5.24.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.24.0/update-IOCM_REGULAR_USE-5.24.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.24.0/update-dev-5.24.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.24.0/update-storescp-5.24.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.24.1/update-AS_RECEIVED-5.24.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.24.1/update-DCM4CHEE-5.24.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.24.1/update-IOCM_REGULAR_USE-5.24.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.24.1/update-dev-5.24.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.24.1/update-storescp-5.24.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.25.0/update-dev-5.25.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.26.0/update-AS_RECEIVED-5.26.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.26.0/update-DCM4CHEE-5.26.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.26.0/update-IOCM_REGULAR_USE-5.26.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.26.0/update-dev-5.26.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.26.0/update-storescp-5.26.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.26.1/update-dev-5.26.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.28.0/update-AS_RECEIVED-5.28.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.28.0/update-DCM4CHEE-5.28.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.28.0/update-IOCM_REGULAR_USE-5.28.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.28.0/update-IOCM_EXPIRED-5.28.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.28.0/update-IOCM_PAT_SAFETY-5.28.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.28.0/update-IOCM_QUALITY-5.28.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.28.0/update-IOCM_WRONG_MWL-5.28.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.29.1/update-AS_RECEIVED-5.29.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.29.1/update-DCM4CHEE-5.29.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.29.1/update-IOCM_REGULAR_USE-5.29.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.29.1/update-WORKLIST-5.29.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.29.1/update-dev-5.29.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.29.1/update-storescp-5.29.1.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.29.2/update-AS_RECEIVED-5.29.2.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.29.2/update-DCM4CHEE-5.29.2.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.29.2/update-IOCM_REGULAR_USE-5.29.2.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.29.2/update-dev-5.29.2.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.29.2/update-storescp-5.29.2.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.30.0/update-AS_RECEIVED-5.30.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.30.0/update-DCM4CHEE-5.30.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.30.0/update-IOCM_REGULAR_USE-5.30.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.30.0/update-dev-5.30.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.30.0/update-storescp-5.30.0.ldif
$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/5.30.0/update-ui-config.ldif




$LDAP_SDK/tools/ldapdelete -h localhost -p 10389 -D "uid=admin,ou=system" -w secret --clientSideSubtreeDelete "ou=realm-management,dc=dcm4che,dc=org"
$LDAP_SDK/tools/ldapdelete -h localhost -p 10389 -D "uid=admin,ou=system" -w secret --clientSideSubtreeDelete "ou=users,dc=dcm4che,dc=org"




cd $APACHEDS_HOME/apacheds-2.0.0-M20/bin

./apacheds.sh stop
sleep 5

while is_service_running; do
echo "Service is still running"
    sleep 2
done

echo "Service stopped successfully"

./apacheds.sh start

TRIES=30
WAIT=3

while /bin/netstat -an | /bin/grep \:10389 | /bin/grep LISTEN ; [ $? -ne 0 ]; do
    let TRIES-=1
    if [ $TRIES -gt 1 ]; then
            sleep $WAIT
    fi
done

sleep 9


$LDAP_SDK/tools/ldapmodify -h localhost -p 10389 -D "uid=admin,ou=system" -w secret -a -f $currentpath/dcm4chee-arc-5.30.0-mysql-secure/ldap/default-users.ldif


cd $APACHEDS_HOME/apacheds-2.0.0-M20/bin

./apacheds.sh stop
sleep 5

while is_service_running; do
echo "Service is still running"
    sleep 2
done

echo "Service stopped successfully"

./apacheds.sh start

TRIES=30
WAIT=3

while /bin/netstat -an | /bin/grep \:10389 | /bin/grep LISTEN ; [ $? -ne 0 ]; do
    let TRIES-=1
    if [ $TRIES -gt 1 ]; then
            sleep $WAIT
    fi
done

sleep 9

echo "Successfully completed the upgrade configuration for Apacheds Server."
