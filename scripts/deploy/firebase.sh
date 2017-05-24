#!/usr/bin/env bash

FB_PROJ=$1
: ${FB_PROJ:=default}

echo "================ Deploy to Firebase ($FB_PROJ) ========================"
firebase deploy --token "$FIREBASE_TOKEN" --project $FB_PROJ
