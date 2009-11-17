# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="2"
inherit eutils qt4

DESCRIPTION="Simple Notes"
HOMEPAGE="http://znotes.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/znotes/${PV}/znotes-${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_compile() {
	lrelease znotes.pro || die "lrelease failed"
	eqmake4 || die "eqmake failed"
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake failed"
	use doc && dodoc CHANGELOG LICENSE INSTALL THANKS
}