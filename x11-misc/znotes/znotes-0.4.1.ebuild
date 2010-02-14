# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="2"
inherit eutils qt4-r2

DESCRIPTION="Lightweigh crossplatform application for notes management"
HOMEPAGE="http://znotes.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/znotes/${PV}/znotes-${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"
MY_LINGUAS="cs ru"

for MY_LINGUA in ${MY_LINGUAS}; do
	IUSE="${IUSE} linguas_${MY_LINGUA/-/_}"
done

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_configure() {
	lrelease znotes.pro || die "lrelease failed"
	qt4-r2_src_configure
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake failed"
	use doc && dodoc CHANGELOG LICENSE INSTALL THANKS
	# Remove unwanted LINGUAS:
	einfo "Keeping these locales: ${LINGUAS}."
	for LINGUA in ${MY_LINGUAS}; do
		if ! use linguas_${LINGUA/-/_}; then
			rm ${D}/usr/share/znotes/translations/znotes_${LINGUA/_/-}.qm
		fi
 	done
}