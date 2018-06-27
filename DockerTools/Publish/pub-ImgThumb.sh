#!/bin/sh


if [[ -z "$1" ]]
then
	echo "========ERROR Parameter======="
	echo ""
	echo " USAGE: $0 [container id]"
	echo ""
#	exit
fi

svnDir="/opt/inspection/SVN/go-imageupload"

echo "svn checkout......"
svn co http://jiayulong@175.25.50.70:8899/svn/other/10-Online/10-Product/11-INSPECTION/project/go-imageupload --username compile --password '18N64gY\GsbH\q1TL73e' $svnDir #/opt/wwwroot

echo "svn checkout done."
echo ""
echo ""
echo ""
cd  $svnDir

