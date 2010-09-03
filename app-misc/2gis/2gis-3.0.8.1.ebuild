# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Proprietary freeware multimedia map of several Russian and Ukrainian towns"
HOMEPAGE="http://2gis.ru"
SRC_URI="http://download.2gis.ru/arhives/2GISShell-${PV}.orig.zip"

LICENSE="2Gis-ru"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+data"

DEPEND="app-arch/unzip"
RDEPEND="app-emulation/wine
	data? ( app-misc/2gis-data )"

pkg_setup() {
	check_license "${FILESDIR%/files}"/../../licenses/${LICENSE}
}

src_install() {
	insinto /opt/${PN}
	doins -r 2gis/3.0/* || die

	make_wrapper 2gis "wine grym.exe -nomta" /opt/${PN}
	make_desktop_entry 2gis 2Gis || die
}
