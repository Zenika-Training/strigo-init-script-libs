sudo apt install zip

# Function for zip a directory, and launch a http server for download it
# Use it downloadDir "workspace" "formation"
downloadDir () { 
    DIR_NAME=$1;
    ZIP_NAME=$2;
    mkdir $ZIP_NAME;
    rsync -av --progress ./$DIR_NAME ./$ZIP_NAME/ --filter=':- .gitignore' > /dev/null;
    zip -r $ZIP_NAME.zip $ZIP_NAME > /dev/null;
    echo "http://${PUBLIC_DNS}:8080/$ZIP_NAME.zip";
    echo "Ctr + C when finished";
    npx http-server -p 8080 > /dev/null;
}