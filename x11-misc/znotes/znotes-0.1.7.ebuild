# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="2"
inherit eutils qt4

DESCRIPTION="Simple Notes"
HOMEPAGE="http://www.qt-apps.org/content/show.php/zNotes?content=113117"
SRC_URI="http://www.qt-apps.org/CONTENT/content-files/113117-${PN}-${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake4
}

src_install() {
	dobin ${PN} || die "dobin failed"
	make_desktop_entry "${PN}"
}