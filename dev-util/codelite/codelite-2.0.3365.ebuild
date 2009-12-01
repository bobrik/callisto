# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="powerful open-source, cross platform IDE for the C/C++"
HOMEPAGE="http://www.codelite.org/"
SRC_URI="mirror://sourceforge/codelite/codelite-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gdb"

RDEPEND="
	>=x11-libs/wxGTK-2.8.0
	gdb? ( sys-devel/gdb )"
DEPEND="${RDEPEND}"

src_compile() {
	cd "${S}"
	./configure --prefix=/usr || die "configure failed"
	emake -j1 || die "make failed"
}

src_install() {
	einstall DESTDIR="${D}" install || die "install failed"
}

