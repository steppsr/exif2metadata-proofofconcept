#!/bin/bash

appdir=`pwd`

collection_folder="./collections"
ready_folder="./ready"

clear

json_collection=""

# get new collection name from user
read -p "New collection name (spaces will be converted to underscores): " collection_name
colleciton_name="${collection_name// /_}"

# get a uuid for the new collection
collection_id=`uuidgen`

# get new collection description
read -p "$collection_name Description: " collection_description

# get collection icon, banner, and feature images
echo ""
echo "Marketplaces use a variety of images to display for your collection."
echo "It is recommended to use the following:"
echo "   icon image (350x350 pixels)"
echo "   banner image (1400x400 pixels)"
echo "   feature image (600x400)"
echo ""
echo "Images will be auto-uploaded for long-term storage."
echo ""
read -p "   Icon image (enter for none): " icon_image
read -p "   Banner image (enter for none): " banner_image
read -p "   Feature image (enter for none): " feature_image

# make a json object for the collection metadata
json_collection=`jq -n --arg id "$collection_id" --arg name "$collection_name" --argjson attributes "[$images]" '$ARGS.named' `

# append attributes into the attributes array
json_collection=`echo $json_collection | jq	'.attributes += [{"type":"description", "value": "'"$collection_description"'"}]'`
json_collection=`echo $json_collection | jq	'.attributes += [{"type":"icon", "value": "'"$icon_uri"'"}]'`
json_collection=`echo $json_collection | jq	'.attributes += [{"type":"banner", "value": "'"$banner_uri"'"}]'`
json_collection=`echo $json_collection | jq	'.attributes += [{"type":"feature", "value": "'"$feature_uri"'"}]'`

# other attributes
echo ""
echo "Do you want to add additional attributes for the collection?"
echo "Common attributes are: website, social accounts such as twitter, etc."
echo ""

b_add_attribute=""
until [ "$b_add_attribute" == "n" ]
do
read -p "Add attribute (y/n)? " b_add_attribute
if [ "$b_add_attribute" == "y" ]; then
    read -p "Attribute name : " new_att_name
    read -p "Attribute value: " new_att_value
    json_collection=`echo $json_collection | jq '.attributes += [{"type":"'"$new_att_name"'", "value": "'"$new_att_value"'"}]'`
fi
done

# create file with new collection name, id, description, etc.
echo ""
echo "Collection Folder: $collection_folder"
echo "Collection Name  : $collection_name"

printf "$json_collection"  >$collection_folder/"${collection_name// /_}".json

