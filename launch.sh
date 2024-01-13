#!/bin/bash -ex

xcodegen
xcodebuild build -project SimpleBudget.xcodeproj -sdk iphonesimulator -configuration Debug -scheme simple-budget -derivedDataPath ./.build | xcode-build-server parse -a
#xcrun simctl uninstall MyPhone com.corybuecker.SimpleBudget
xcrun simctl install MyPhone .build/Build/Products/Debug-iphonesimulator/simple-budget.app
xcrun simctl launch --console-pty --terminate-running-process MyPhone dev.corybuecker.simple-budget
