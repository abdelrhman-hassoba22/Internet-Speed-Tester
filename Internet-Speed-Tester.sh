#!$BASH

# this script to check from conection and network speed.

echo "Internet connectivity test..."
ping -c 4 google.com > /dev/null  2>&1

if [ $? -eq 0 ]; then
echo "Internet connection successful."
else 
    echo "Internet connection failed."
    exit 1
fi

# speed test with curl command.
echo "Download speed test."
download_speed="$(curl -s -w "%{speed_download}" -o /dev/null https://testfiles.ah-apps.de/10MB.bin)"

# convert bits to megabits.
d_s_mb=$(echo " $download_speed / 1000000 " | bc -l | cut -c 1-4)
echo "Download speed: $d_s_mb MB/sec"

# upload test.
path_TF=/tmp/testfile.bin
dd if=/dev/zero bs=1M count=10 of=$path_TF > /dev/null 2>&1

echo "Upload test..."
upload_speed=$(curl -s -w "%{speed_upload}" -o /dev/null -T $path_TF https://librespeed.org)

# convert bits to megabits.
u_s_mb=$(echo " $upload_speed / 1000000 " | bc -l | cut -c 1-4)
echo "upload speed $u_s_mb MB/sec"

# rm (testfile.bin).
rm $path_TF > /dev/null 2>&1
