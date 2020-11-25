#!/usr/bin/env bash

function test_cloud
{
   CLOUD_DETAILS=$(curl -X POST  \-H 'Content-type:application/json' \https://sub-account-testing.cloudinary.com/create_sub_account \--data '{"prefix" : "ios-test-cloud"}')
   
   echo ${CLOUD_DETAILS} | python -c 'import json,sys;c=json.load(sys.stdin)["payload"];print("cloudinary://%s:%s@%s" % (c["cloudApiKey"], c["cloudApiSecret"], c["cloudName"]))'
}

test_cloud
