# Based on http://stackoverflow.com/a/19030872/526985
XBUILD=/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild
PROJECT_ROOT=.
PROJECT=$(PROJECT_ROOT)/Cloudinary.xcodeproj
TARGET=Cloudinary
UNIVERAL=build/Release-universal

all: $(UNIVERAL)/lib$(TARGET).a

build/libi386.a:
	$(XBUILD) -project $(PROJECT) -target $(TARGET) -sdk iphonesimulator -configuration Release clean build
	-mv $(PROJECT_ROOT)/build/Release-iphonesimulator/lib$(TARGET).a $@

build/libArmv7.a:
	$(XBUILD) -project $(PROJECT) -target $(TARGET) -sdk iphoneos -arch armv7 -configuration Release clean build
	-mv $(PROJECT_ROOT)/build/Release-iphoneos/lib$(TARGET).a $@

build/libArmv7s.a:
	$(XBUILD) -project $(PROJECT) -target $(TARGET) -sdk iphoneos -arch armv7s -configuration Release clean build
	-mv $(PROJECT_ROOT)/build/Release-iphoneos/lib$(TARGET).a $@

build/libArm64.a:
	$(XBUILD) -project $(PROJECT) -target $(TARGET) -sdk iphoneos -arch arm64 -configuration Release clean build
	-mv $(PROJECT_ROOT)/build/Release-iphoneos/lib$(TARGET).a $@

$(UNIVERAL)/lib$(TARGET).a: build/libi386.a build/libArmv7.a build/libArmv7s.a build/libArm64.a
	-mkdir $(UNIVERAL)
	-cp -rf build/Release-iphoneos/include $(UNIVERAL)/
	lipo -create -output $(UNIVERAL)/lib$(TARGET).a $^

clean:
	-rm -f *.a *.dll
	-rm -rf build
