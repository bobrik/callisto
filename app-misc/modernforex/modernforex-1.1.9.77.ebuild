# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: modernforex-1.1.9.77.ebuild 2009/12/08 02:08:15 szver Exp $

EAPI="2"

inherit rpm eutils

MY_PN="ModernForex"
DESCRIPTION="FOREX trading and technical analis terminal"
HOMEPAGE="http://www.fxclub.org"
LICENSE="GPL-2"
SRC_URI="http://download.fxclub.org/Modern/modernforex.rpm"
SLOT="0"
KEYWORDS="~x86"

DEPEND="=x11-libs/qt-3.3.8*"

src_install() {
	insinto /usr/share/icons
	cp "${WORKDIR}"/usr/local/share/apps/modernforex/etc/modern{,forex}.png
	doins "${WORKDIR}"/usr/local/share/apps/modernforex/etc/modernforex.png
	
	insinto /opt/"${PN}"
	doins -r "${WORKDIR}"/usr/local/share
	doins -r "${WORKDIR}"/usr/local/lib

	#~ exeinto /opt/"${PN}"/lib
	#~ doexe "${WORKDIR}"/usr/local/lib/*

	exeinto /opt/"${PN}"/bin
	doexe "${WORKDIR}"/usr/local/bin/*

	make_desktop_entry "/opt/modernforex/bin/modernforex" "ModernForex" "modernforex" "Application"
}
