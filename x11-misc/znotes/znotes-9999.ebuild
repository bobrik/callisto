# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="2"
inherit eutils qt4-r2

DESCRIPTION="Lightweigh crossplatform application for notes management"
HOMEPAGE="http://znotes.sourceforge.net/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE="doc"

EGIT_REPO_URI="git://github.com/proton/zNotes.git"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_configure() {
	lrelease znotes.pro || die "lrelease failed"
	qt4-r2_src_configure
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake failed"
	use doc && dodoc CHANGELOG LICENSE INSTALL THANKS
}