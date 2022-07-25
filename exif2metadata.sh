#!/bin/bash
filename=$1
cid=$2
collection=$3

collection_json=`cat collections/"$collection".json`

format="CHIP-0007"
minter=""
sens="false"

response=`exiftool -s "ready/$filename"`

md_make=`echo "$response" | grep "^Make" | cut --fields 2 --delimiter=: | cut -c 2-`
md_model=`echo "$response" | grep "^Model" | cut --fields 2 --delimiter=: | cut -c 2-`
md_xres=`echo "$response" | grep "^XResolution" | cut --fields 2 --delimiter=: | cut -c 2-`
md_yres=`echo "$response" | grep "^YResolution" | cut --fields 2 --delimiter=: | cut -c 2-`
md_modifydate=`echo "$response" | grep "^ModifyDate" | cut -c 34-`
md_photographer=`echo "$response" | grep "^Rights" | cut --fields 2 --delimiter=: | cut -c 2-`
imgdesc=`echo "$response" | grep "^ImageDescription" | cut --fields 2 --delimiter=: | cut -c 2-`
imgtitle=`echo "$response" | grep "^Title" | cut --fields 2 --delimiter=: | cut -c 2-`
md_iso=`echo "$response" | grep "^ISO" | cut --fields 2 --delimiter=: | cut -c 2-`
md_shutterspeed=`echo "$response" | grep "^ShutterSpeedValue" | cut --fields 2 --delimiter=: | cut -c 2-`
md_aperture=`echo "$response" | grep "^ApertureValue" | cut --fields 2 --delimiter=: | cut -c 2-`
md_lensmodel=`echo "$response" | grep "^LensModel" | cut --fields 2 --delimiter=: | cut -c 2-`
md_keywords=`echo "$response" | grep "^Keywords" | cut --fields 2 --delimiter=: | cut -c 2-`
md_imagesize=`echo "$response" | grep "^ImageSize" | cut --fields 2 --delimiter=: | cut -c 2-`
md_megapixels=`echo "$response" | grep "^Megapixels" | cut --fields 2 --delimiter=: | cut -c 2-`
md_focallength=`echo "$response" | grep "^FocalLength " | cut --fields 2 --delimiter=: | cut -c 2-`
md_location=`echo "$response" | grep "^Location" | cut --fields 2,3 --delimiter=: | cut -c 2-`

[ -z "$imgtitle" ] || echo "Name: $imgtitle"
[ -z "$imgdesc" ] || echo "Description: $imgdesc"
[ -z "$md_keywords" ] || echo "Keywords: $md_keywords"
[ -z "$md_lensmodel" ] || echo "Lens: $md_lensmodel"
[ -z "$md_photographer" ] || echo "Artist: $md_photographer"
[ -z "$md_location" ] || echo "Location: $md_location"

temp="$md_make$md_model"
[ -z "$temp" ] || camera="$md_make $md_model" && echo "Camera: $camera"

md_modifydate=`echo $md_modifydate | cut -c 1-10 | tr ':' '-'`
[ -z "$md_modifydate" ] || echo "Date: $md_modifydate"

temp="$md_imagesize$md_megapixels$md_xred$md_yres"
[ -z "$temp" ] || size="$md_imagesize • $md_megapixels megapixels • $md_xres dpi x $md_yres dpi" && echo "Size: $size"

details="$md_focallength • f/$md_aperture • $md_shutterspeed s • ISO $md_iso" && echo "Details: $details"

image_json=`jq -n \
    --arg format "$format" \
    --arg name "$imgtitle" \
    --arg description "$imgdesc" \
    --arg minting_tool "$minter" \
    --arg sensitive_content "$sens" \
    --argjson attributes "[]" \
    --argjson collection "$collection_json" \
    '$ARGS.named'`
image_json=`echo $image_json | jq '.attributes += [{"trait_type": "Artist", "value": "'"$md_photographer"'"}]'`
image_json=`echo $image_json | jq '.attributes += [{"trait_type": "Date", "value": "'"$md_modifydate"'"}]'`
image_json=`echo $image_json | jq '.attributes += [{"trait_type": "Camera", "value": "'"$camera"'"}]'`
image_json=`echo $image_json | jq '.attributes += [{"trait_type": "Lens", "value": "'"$md_lensmodel"'"}]'`
image_json=`echo $image_json | jq '.attributes += [{"trait_type": "Size", "value": "'"$size"'"}]'`
image_json=`echo $image_json | jq '.attributes += [{"trait_type": "Details", "value": "'"$details"'"}]'`
image_json=`echo $image_json | jq '.attributes += [{"trait_type": "Location", "value": "'"$md_location"'"}]'`
image_json=`echo $image_json | jq '.attributes += [{"trait_type": "Keywords", "value": "'"$md_keywords"'"}]'`

metadata_folder="./metadata"
printf "$image_json" > $metadata_folder/"$cid.json"

