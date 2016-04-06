WORKSPACE=
SCHEME=
CONFIGURATION=
EXPORT_TEAM_ID=
EXPORT_METHOD=
define EXPORT_PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>teamID</key>
        <string>$(EXPORT_TEAM_ID)</string>
        <key>method</key>
        <string>$(EXPORT_METHOD)</string>
</dict>
</plist>
endef
export EXPORT_PLIST

all: $(SCHEME).ipa

$(SCHEME).xcarchive:
	xcodebuild archive -configuration "$(CONFIGURATION)" -workspace "$(WORKSPACE)" -scheme "$(SCHEME)" -derivedDataPath ./ -archivePath "./$(SCHEME).xcarchive" > build.log

exportPlist.plist:
		echo "$$EXPORT_PLIST" > exportPlist.plist

$(SCHEME).ipa: $(SCHEME).xcarchive exportPlist.plist
	xcodebuild -exportArchive -exportOptionsPlist exportPlist.plist -archivePath "./$(SCHEME).xcarchive" -exportPath ./ >> build.log

clean:
	-rm -rf build.log ./Build ./ModuleCache
	-rm *.ipa info.plist
	-rm -rf *.xcarchive
	-rm exportPlist.plist

.PHONY:clean
