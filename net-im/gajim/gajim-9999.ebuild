# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib python eutils mercurial

EHG_REPO_URI="http://hg.gajim.org/gajim"
EHG_REVISION="default"

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="http://www.gajim.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="avahi dbus gnome idle libnotify nls spell srv trayicon X xhtml"

DEPEND="|| (
		( <dev-lang/python-2.5[sqlite=] dev-python/pysqlite )
		>=dev-lang/python-2.5
	)
	dev-python/pygtk
	sys-devel/gettext
	dev-util/intltool
	dev-util/pkgconfig"

RDEPEND="gnome? ( dev-python/gnome-python-extras
		dev-python/gnome-python-desktop
	)
	dbus? ( dev-python/dbus-python dev-libs/dbus-glib )
	libnotify? ( x11-libs/libnotify )
	xhtml? ( dev-python/docutils )
	srv? ( net-dns/bind-tools )
	idle? ( x11-libs/libXScrnSaver )
	spell? ( app-text/gtkspell )
	avahi? ( net-dns/avahi )
	asyncns? ( dev-python/libasyncns-python )
	dev-python/pyopenssl"

S="${WORKDIR}/${PN}"

DOCS="AUTHORS NEWS README"

pkg_setup() {
	if ! use dbus; then
		if use libnotify; then
			eerror "The dbus USE flag is required for libnotify support"
			die "USE=\"dbus\" needed for libnotify support"
		fi
		if use avahi; then
			eerror "The dbus USE flag is required for avahi support"
			die "USE=\"dbus\" needed for avahi support"
		fi
	fi

	if use avahi; then
		if ! built_with_use net-dns/avahi dbus gtk python; then
			eerror "The following USE flags are required for correct avahi"
			eerror "support: dbus gtk python"
			die "Please rebuild avahi with these use flags enabled."
		fi
	fi

}

src_prepare() {
	epatch "${FILESDIR}/autotools_install_pyfiles_in_pkglibdir.patch"
	epatch "${FILESDIR}/dont_run_configure_in_autogen.patch"

	./autogen.sh
}

src_configure() {
	local myconf

	if ! use gnome; then
		myconf="${myconf} $(use_enable trayicon)"
	fi

	econf $(use_enable nls) \
		$(use_with X x) \
		--docdir="/usr/share/doc/${PF}" \
		--prefix="/usr" \
		--libdir="$(python_get_sitedir)" \
		${myconf} || die "econf failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README
}

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/gajim/
}

pkg_postrm() {
	python_mod_cleanup $(python_get_sitedir)/gajim/
}
