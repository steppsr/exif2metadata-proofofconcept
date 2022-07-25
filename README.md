# exif2metadata-proofofconcept

> This script is a proof of concept. The goal is to build a script to be able to build a metadata file
> by extracting EXIF data from a photograph. Also, includes a preparation script to build some collection
> metadata that can be reused for other files.

### Goals
* script to create collection metadata
* script to extract EXIF data from a photography
* integrate the collection data with the EXIF data to build a final metadata file.

### Installing
You can install the application by running the following install command. This will basically create all the needed subfolders for you.
```
bash install.sh
```

### Preparing to run
You will need to put your photograph into the `ready` subfolder.

### Running the script(s)

**prep.sh**

If you will be creating a metadata file for a new collection, you'll need to run the `prep.sh` script first which will build the
collection data that will be used in the main `exif2metadata.sh` script.

```
bash prep.sh
```

Follow/answer the on screen prompts and the file will be built. If you need, you can always rerun this script to build the file again.
The collection file will be a JSON file and saved into the `collections` subfolder. The file will be your `collection_name.json`.
For example, if I create a collection called "StevesPhotos" then the filename will be `StevesPhotos.json`.

**exif2metadata.sh**

The `exif2metadata.sh` script will extract the EXIF data from the photo and then use that with the collection data to build the final
metadata file. The metadata file will be in the `metadata` subfolder once the script completes.

You will need pass in a few parameters when running this script.
1. the filename of the photograph
2. the name for the metadata file (without an extension...  for example:  `StevesPhoto_001` )
3. the name of the collection (without an extension...   for example:  `StevesPhotos` )

The you can run the script like below:

```
bash exif2metadata.sh TravelingMan.jpg TravelingMan_001.jpg TravelingManCollection
```

