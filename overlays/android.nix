self: super:

{
  androidComposition = self.androidenv.composeAndroidPackages {
    toolsVersion = "25.2.5";
    platformToolsVersion = "28.0.1";
    buildToolsVersions = [ "27.0.3" ];
    includeEmulator = false;
    emulatorVersion = "27.2.0";
    platformVersions = [ "26" "27" "28" ];
    includeSources = false;
    includeDocs = false;
    includeSystemImages = false;
    systemImageTypes = [ "default" ];
    abiVersions = [ "armeabi-v7a" ];
    lldbVersions = [ "2.0.2558144" ];
    cmakeVersions = [ "3.6.4111459" ];
    includeNDK = false;
    ndkVersion = "16.1.4479499";
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
    includeExtras = [ "extras;google;gcm" ];
  };
}
