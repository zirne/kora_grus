#!/bin/bash

# For building relevant files, use Linux or WSL

# Consts
ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LATEST_ARCHIVES_DIR="$ROOT_DIR/build/latest_archives"
LATEST_SW_DIR="$ROOT_DIR/build/latest_steam_workshop"
LATEST_SW_UPLOAD_DIR="$LATEST_SW_DIR/upload_me"
LATEST_SW_UNI_DIR="$LATEST_SW_UPLOAD_DIR/universal"
LATEST_SW_WORKSHOP_PREVIEW_IMAGE="$ROOT_DIR/resources/steam_image_640x360.jpg"
ZIP_FILE_PATH="kora_grus.zip"
SCS_FILE_PATH="kora_grus.scs"

# Start in root dir
cd "$ROOT_DIR"

MANIFEST_VERSION=$(grep package_version src/manifest.sii | cut -d ':' -f2 | tr -d ' ' | sed 's|"||g')

# Check if zip is installed
if ! command -v zip 2>&1 > /dev/null
then
    echo "Make sure to have zip installed!"
    exit 1
fi

# Cleanup from previous latest builds in case something went fucky
rm -rf "$LATEST_ARCHIVES_DIR"
rm -rf "$LATEST_SW_DIR"

mkdir -p "$LATEST_ARCHIVES_DIR"
mkdir -p "$LATEST_SW_UPLOAD_DIR"

# Package archives
pushd src
zip "$LATEST_ARCHIVES_DIR/$ZIP_FILE_PATH" *
popd 
cp -a "$LATEST_ARCHIVES_DIR/$ZIP_FILE_PATH" "$LATEST_ARCHIVES_DIR/$SCS_FILE_PATH"

# Prepare files for Steam Workshop usage
cp -a ./src "$LATEST_SW_UNI_DIR"

cat << EOF > "${LATEST_SW_UPLOAD_DIR}/versions.sii"
SiiNunit
{
package_version_info : .universal
{
    package_name: "universal"
}
}
EOF

LATEST_SW_PREVIEW_JPG="$LATEST_SW_DIR/preview.jpg"
cp "$LATEST_SW_WORKSHOP_PREVIEW_IMAGE" "$LATEST_SW_PREVIEW_JPG"

echo "Done!"
echo "Your latest release will be found in \"$LATEST_ARCHIVES_DIR\", and the Steam Workshop content can be found in \"$LATEST_SW_DIR/\"."
echo "For Steam Workshop upload, use \"$LATEST_SW_UPLOAD_DIR\" for Mod data:Folder and \"$LATEST_SW_PREVIEW_JPG\" for Mod:Preview image."