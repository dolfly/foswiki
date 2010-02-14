for i in `ls -1p`
do
	if [ -d $i ]
	then
		zip -r ${i%/}.zip $i
		rm -rf $i
	fi
done