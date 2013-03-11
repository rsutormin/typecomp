#!/bin/sh

PACKAGE_DIR='kidl-compiler'
rm -rf $PACKAGE_DIR

# make a directory in which to package everything
mkdir -p $PACKAGE_DIR

# copy the files into the package directory.
rsync --exclude '.git' --exclude 'dist' --exclude 'Makefile' --exclude 'deploy.cfg' --exclude 'DEPENDENCIES' -arv ../. $PACKAGE_DIR/.

# insert #!/usr/bin/env perl at the top of each script
for s in $PACKAGE_DIR/scripts/*.pl
do
	echo '#!/usr/bin/env perl' | cat - $s > temp && mv temp $s
	echo $s
done

# put the build script in place
cp Build.PL $PACKAGE_DIR/
cp INSTALL.txt $PACKAGE_DIR/
cp -r t $PACKAGE_DIR/


cd $PACKAGE_DIR
perl ./Build.PL
./Build manifest
./Build realclean
rm -f MANIFEST.SKIP.bak
cd ..

tar -cvf $PACKAGE_DIR.tar $PACKAGE_DIR
gzip $PACKAGE_DIR.tar
rm -rf $PACKAGE_DIR
