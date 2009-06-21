# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Mitter is a client for Twitter."
HOMEPAGE="http://code.google.com/p/mitter/"
SRC_URI="http://mitter.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~s390 x86"
IUSE="+gtk tty cmd alt-gtk-layout"

DEPEND="gtk? ( dev-python/pygtk )
	dev-python/simplejson"
RDEPEND="dev-python/setuptools"


src_compile() {
	cd ${WORKDIR}
	use gtk || rm "${WORKDIR}/${P}/mitterlib/ui/ui_pygtk.py"
	use tty || rm "${WORKDIR}/${P}/mitterlib/ui/ui_tty.py"
	use cmd || rm "${WORKDIR}/${P}/mitterlib/ui/ui_cmd.py"
	if use alt-gtk-layout && use gtk; then
		epatch ${FILESDIR}/mitter-nice-update.diff
	fi
	(! use gtk) && (! use tty) && (! use cmd) && die "You should select something interface"
}

src_install() {
	distutils_src_install
	use gtk && (make_desktop_entry "mitter" "Mitter" "mitter.png" "Application;Network" || die "make_desktop_entry failed")
}
