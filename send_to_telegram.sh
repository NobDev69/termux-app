#!/bin/bash

# Arguments
APK_DIR_PATH=$1

# Telegram Bot Token and Chat ID (set from environment variables)
BOT_TOKEN=${BOT_TOKEN}
CHAT_ID=${CHAT_ID}

# Function to send file to Telegram
send_file() {
  local file_path=$1
  local file_name=$(basename "$file_path")
  
  # Upload the file to Telegram
  curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" \
    -F chat_id="${CHAT_ID}" \
    -F document=@"$file_path" \
    -F caption="Sending ${file_name}"
}

# Send all APK files and sha256sum file
echo "Sending APK files and sha256sum to Telegram..."

# Loop through each APK file and send it
for apk_file in ${APK_DIR_PATH}/*.apk; do
  send_file "$apk_file"
done

# Send sha256sum file
sha256sum_file="${APK_DIR_PATH}/${APK_BASENAME_PREFIX}_sha256sums"
if [ -f "$sha256sum_file" ]; then
  send_file "$sha256sum_file"
else
  echo "No sha256sum file found to send."
fi

echo "All files sent to Telegram."
