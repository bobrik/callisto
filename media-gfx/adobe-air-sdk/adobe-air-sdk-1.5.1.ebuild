# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Adove AIR-SDK"
HOMEPAGE="http://www.adobe.com/products/air/tools/sdk/"
SRC_URI="http://airdownload.adobe.com/air/lin/download/latest/AdobeAIRSDK.tbz2"
RESTRICT="fetch"

LICENSE="AdobeAirSDK"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

pkg_nofetch() {
	einfo "Please go to ${HOMEPAGE}, read and accept the EULA and download"
	einfo "  Adobe AIR-SDK for Linux"
	einfo "Place the file AdobeAIRSDK.tbz2 in /usr/portage/distfiles."
	echo
	einfo "New versions of Adobe AIR will break the ebuild"
	einfo " (i.e. the versionnumber will be wrong)"
}

src_install() {
	insinto /opt/AirSDK
	cp -R * ${D}/opt/AirSDK || die "installation failed"
	fperms 755 /opt/AirSDK/bin/*
	dobin ${FILESDIR}/airstart || die "airstart installation failed"
	dodir /opt/AirApps || die "failed to make /opt/AirApps"
}

pkg_postinst() {
	einfo "To install air app just unzip it contents to /opt/AirApps"
	echo
	einfo "To start air app use command airstart <appname>"
	einfo "where appname is app dirname in /opt/AirApps"
}