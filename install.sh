#!/bin/bash

##################
# INSTALL SCRIPT #
##################

appdir=`pwd`

echo ""
echo "Installing into $appdir directory."

[ ! -d "$appdir/collections" ] && mkdir "$appdir/collections" && echo "collections sub-directory created."
[ ! -d "$appdir/metadata" ] && mkdir "$appdir/metadata" && echo "metadata sub-directory created."
[ ! -d "$appdir/ready" ] && mkdir "$appdir/ready" && echo "ready sub-directory created."

echo "Making the script executable."
chmod +x ./prep.sh
chmod +x ./exif2metadata.sh

echo "Complete."

echo ""
echo "Using the scripts."
echo ""
echo "   Your photos should be copied into the 'ready' sub-folder. This will be the folder where the script looks for your photo."
echo ""
echo "   The collection data will be written out to the collections folder. You can create the collection data by running the"
echo "      prep.sh script. Here is the command you will run:"
echo ""
echo "      > bash prep.sh"
echo ""
echo "   The metadata will be wrtten out to the metadata folder. The full metadata file will be created by running the exif2metadata"
echo "      script. You will need to have a collection created first. The metadata will use both the collection data, and the EXIF"
echo "      data extracted from your photo to build the final metadata file. Here is the command to run to build the metadata:"
echo ""
echo "      > bash exif2metadata.sh PHOTO_FILENAME METADATA_FILENAME COLLECTION_FILENAME"
echo ""
echo "---"

