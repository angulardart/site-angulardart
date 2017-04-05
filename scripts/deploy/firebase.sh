#!/usr/bin/env sh

FB_PROJ=$1
: ${FB_PROJ:=default}

echo "================ Deploy to Firebase ========================"
firebase deploy --token "${FIREBASE_TOKEN}" --non-interactive --project $FB_PROJ
