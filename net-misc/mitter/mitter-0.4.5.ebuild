# Copyright 2008 Ivan Babrou
# Distributed under the terms of the GNU General Public License v2

inherit distutils

DESCRIPTION="Mitter is a client for Twitter."
HOMEPAGE="http://code.google.com/p/mitter/"
SRC_URI="http://mitter.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~s390 x86"
IUSE="gtk tty cmd alt-gtk-layout"

DEPEND="gtk? ( dev-python/pygtk )
	dev-python/simplejson"
RDEPEND="dev-python/setuptools"


src_compile() {
	cd ${WORKDIR}
	if ! use gtk; then
		rm ${WORKDIR}/${P}/mitterlib/ui/ui_pygtk.py
	fi
	if ! use tty; then
		rm ${WORKDIR}/${P}/mitterlib/ui/ui_tty.py
	fi
	if ! use cmd; then
		rm ${WORKDIR}/${P}/mitterlib/ui/ui_cmd.py
	fi
	if use alt-gtk-layout && use gtk; then
		epatch ${FILESDIR}/mitter-nice-update.diff
	fi
}

src_install() {
	distutils_src_install
	if use gtk; then
		mkdir -p ${D}/usr/share/applications/
		cp ${FILESDIR}/mitter.desktop ${D}/usr/share/applications/
	fi
}
