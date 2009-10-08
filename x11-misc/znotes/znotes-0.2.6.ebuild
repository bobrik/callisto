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

LANGS="ru"
for lng in ${LANGS} ; do
	IUSE="${IUSE} linguas_${lng}"
done

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake failed"
	for lng in ${LANGS} ; do
		if use linguas_${lng} ; then
			insinto /usr/share/znotes/
			doins "translations/znotes_${lng}.qm" | die "emake failed"
		fi
	done
}