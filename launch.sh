#!/bin/bash -ex

#rm -rf SimpleBudget.xcodeproj
#
#xcodegen
#
#xcodebuild clean build -project SimpleBudget.xcodeproj -allowProvisioningUpdates -sdk iphonesimulator
#xcrun simctl install MyPhone build/Debug-iphonesimulator/SimpleBudget.app

#xcode-build-server config -project SimpleBudget.xcodeproj -scheme SimpleBudget

xcodebuild clean build -project SimpleBudget.xcodeproj -allowProvisioningUpdates -sdk iphonesimulator -configuration Debug
xcrun simctl install MyPhone build/Debug-iphonesimulator/SimpleBudget.app
xcrun simctl launch --console-pty --terminate-running-process MyPhone com.corybuecker.SimpleBudget
