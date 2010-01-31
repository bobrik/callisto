# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="2"
inherit eutils qt4 git

DESCRIPTION="Simple lightweight crossplatform application for notes managment"
HOMEPAGE="http://znotes.sourceforge.net/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE="doc"

EGIT_REPO_URI="git://github.com/proton/zNotes.git"

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