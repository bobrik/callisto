# Copyright 2008 Ivan Babrou
# Distributed under the terms of the GNU General Public License v2

inherit distutils subversion

DESCRIPTION="Mitter is a client for Twitter."
HOMEPAGE="http://code.google.com/p/mitter/"

ESVN_REPO_URI="http://mitter.googlecode.com/svn/trunk/"
ESVN_PROJECT="mitter"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~ia64 ~ppc ~s390 ~x86"
IUSE="gtk tty cmd alt-gtk-layout"

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
	if use gtk; then
		# my .desktop file better that time ;-))
		mkdir -p ${D}/usr/share/applications/
		cp ${FILESDIR}/mitter.desktop ${D}/usr/share/applications/
	fi
}

