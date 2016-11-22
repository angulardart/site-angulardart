#!/usr/bin/env sh

echo "================ Deploy to Firebase (dev) ========================"
firebase deploy --token "${FIREBASE_TOKEN}" --project dev
