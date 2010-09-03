# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

DESCRIPTION="Proprietary freeware multimedia map of several Russian and Ukrainian towns (plugins)"
HOMEPAGE="http://plugins.2gis.ru"

LICENSE="2Gis-ru"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="app-arch/unzip
		app-arch/unrar"
RDEPEND=">=app-misc/2gis-3.0.6.1"

IUSE="+addrexport"
SRC_URI="addrexport? ( ${HOMEPAGE}/binary/bin/DGisExport.rar )"


pkg_setup() {
	check_license "${FILESDIR%/files}"/../../licenses/${LICENSE}
}


src_install() {
	insinto /opt/2gis/Plugins/
	# Only required data files were unpacked, so it should be safe to
	# use wildcard.
	doins *.dgxpi *.dll || die
}
