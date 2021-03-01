{ stdenv
, dpkg
, autoPatchelfHook
, wrapGAppsHook
, gtk2
, gtk2-x11
, gdk-pixbuf
, glib
, pcsclite
, openssl
, lib
, fetchurl
}:

stdenv.mkDerivation {
  pname = "safenet";

  version = "9.0.43";

  src = fetchurl {
    url = "https://download.comodo.com/SAC/linux/deb/x64/SafenetAuthenticationClient-9.0.43-0_amd64.deb";
    sha256 = "1an7wyhkwh9fkxg176g2y460wpkpxakyvy4lcv7rwip6pm341jk8";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    gtk2
    gtk2-x11
    gdk-pixbuf
    glib
    pcsclite
    openssl.out
  ];

  unpackPhase = ''
    dpkg -x $src source
    cd source
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ openssl.out ]}:$out/lib")
  '';

  postFixup = ''
    sed 's|-a "$0"||g' -i $out/bin/*
  '';

  installPhase = ''

    mkdir $out
    for f in usr/lib/*; do
      ln -s $(readlink $f | sed "s|/lib/||g") lib/$(basename $f)
    done
    rm -rf usr/lib
    mv lib/udev etc/udev
    mv lib usr/lib

    for f in $(find -type f -iname "*.so*"); do
      patchelf --add-needed libcrypto.so $f
    done

    mv usr/* $out
    rm -rf etc/init.d
    rm -rf etc/rc.d
    mv etc $out/etc

    mkdir -p $out/pcsc/drivers
    cp -rf $out/share/eToken/drivers/aks-ifdh.bundle $out/pcsc/drivers
    chmod +x $out/pcsc/drivers/aks-ifdh.bundle/Contents/Linux/libAksIfdh.so.9.0
    ln -f -s libAksIfdh.so.9.0 $out/pcsc/drivers/aks-ifdh.bundle/Contents/Linux/libAksIfdh.so

    chmod +x $out/share/eToken/shortcuts/*.desktop

    ## the following mess is adapted from postinst ##

    clink ()
    {
      mkdir -p $(dirname $2)
      ln -fs $1 $2
    }

    # kde
    clink $out/share/eToken/shortcuts/SACTools.desktop $out/share/applications/SACTools.desktop
    clink $out/share/eToken/shortcuts/SACMonitor.desktop $out/share/applications/SACMonitor.desktop
    clink $out/share/eToken/shortcuts/SACMonitor.desktop $out/share/autostart/SACMonitor.desktop
    clink $out/share/eToken/shortcuts/SafeNet.directory $out/share/desktop-directories/SafeNet.directory
    clink $out/share/eToken/shortcuts/SafeNet-Authentication-Client.directory $out/share/desktop-directories/SafeNet-Authentication-Client.directory
    clink $out/share/eToken/shortcuts/icons/SACTools.png $out/share/icons/SACTools.png
    clink $out/share/eToken/shortcuts/icons/SACMonitor.png $out/share/icons/SACMonitor.png
    touch $out/share/icons

    # gnome
    clink $out/share/eToken/shortcuts/SACTools.desktop $out/share/applications/SACTools.desktop
    clink $out/share/eToken/shortcuts/SACMonitor.desktop $out/share/applications/SACMonitor.desktop
    #if [ -d $out/share/gnome/autostart/ ] ; then
      clink $out/share/eToken/shortcuts/SACMonitor.desktop $out/share/gnome/autostart/SACMonitor.desktop
    #fi
    clink $out/share/eToken/shortcuts/SafeNet.directory $out/share/desktop-directories/SafeNet.directory
    clink $out/share/eToken/shortcuts/SafeNet-Authentication-Client.directory $out/share/desktop-directories/SafeNet-Authentication-Client.directory
    #if [ -d $out/share/icons/gnome/32x32/apps ] ; then
      clink $out/share/eToken/shortcuts/icons/SACTools.png $out/share/icons/gnome/32x32/apps/SACTools.png
      clink $out/share/eToken/shortcuts/icons/SACMonitor.png $out/share/icons/gnome/32x32/apps/SACMonitor.png
      touch $out/share/icons/gnome
    #fi

    # actual autostart
    clink $out/share/eToken/shortcuts/SACMonitor.desktop $out/etc/xdg/autostart/SACMonitor.desktop
  '';
}
