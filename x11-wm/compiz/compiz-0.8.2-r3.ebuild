# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/compiz/compiz-0.8.2-r2.ebuild,v 1.1 2009/06/12 03:09:39 jmbsvicetto Exp $

EAPI="2"

inherit autotools eutils gnome2-utils multilib

DESCRIPTION="3D composite and windowmanager"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="http://releases.compiz.org/${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+cairo dbus fuse gnome gtk kde kde4 +svg"

DEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/libpng
	>=media-libs/mesa-6.5.1-r1
	>=x11-base/xorg-server-1.1.1-r1
	x11-libs/libX11[xcb]
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libICE
	x11-libs/libSM
	>=x11-libs/libXrender-0.8.4
	>=x11-libs/startup-notification-0.7
	cairo? (
			x11-libs/cairo[X]
	)
	dbus? ( >=sys-apps/dbus-1.0 )
	fuse? ( sys-fs/fuse )
	gnome? (
		>=gnome-base/gnome-control-center-2.16.1:2
		gnome-base/gnome-desktop
		gnome-base/gconf:2
	)
	gtk? (
		>=x11-libs/gtk+-2.8.0:2
		>=x11-libs/libwnck-2.18.3
		x11-libs/pango
	)
	kde? (
		|| ( kde-base/kwin:3.5
			kde-base/kdebase:3.5
		)
		dev-libs/dbus-qt3-old
	)
	kde4? (
		|| (
			kde-base/kwin:4.2
			kde-base/kwin:4.3
			kde-base/kwin:4.4
			kde-base/kwin:live
		)
	)
	svg? (
		>=gnome-base/librsvg-2.14.0:2
		>=x11-libs/cairo-1.0
	)
"

RDEPEND="${DEPEND}
	x11-apps/mesa-progs
	x11-apps/xvinfo"

DEPEND="${DEPEND}
	dev-util/pkgconfig
	x11-proto/damageproto
	x11-proto/xineramaproto"

src_prepare() {

	echo "gtk/gnome/compiz-wm.desktop.in" >> "${S}/po/POTFILES.skip"
	echo "metadata/core.xml.in" >> "${S}/po/POTFILES.skip"

	use gnome || {
		epatch "${FILESDIR}"/${PN}-no-gconf.patch
		ln -s /usr/share/aclocal/gconf-2.m4 acinclude.m4

		# required to apply the above patch
		intltoolize --copy --force || die "intltoolize failed"
		eautoreconf || die "eautoreconf failed"
	}
}

src_configure() {
	econf \
		--disable-gnome-keybindings \
		--enable-librsvg \
		--with-default-plugins \
		$(use_enable cairo annotate) \
		$(use_enable dbus) \
		$(use_enable dbus dbus-glib) \
		$(use_enable fuse) \
		$(use_enable gnome) \
		$(use_enable gnome gconf) \
		$(use_enable gnome metacity) \
		$(use_enable gtk) \
		$(use_enable kde) \
		$(use_enable kde4) \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# Install compiz-manager
	dobin "${FILESDIR}/compiz-manager" || die "dobin failed"

	# Add the full-path to lspci
	sed -i "s#lspci#/usr/sbin/lspci#" "${D}/usr/bin/compiz-manager"

	# Fix the hardcoded lib paths
	sed -i "s#/lib/#/$(get_libdir)/#g" "${D}/usr/bin/compiz-manager"

	# Create gentoo's config file
	dodir /etc/xdg/compiz

	cat <<- EOF > "${D}/etc/xdg/compiz/compiz-manager"
	COMPIZ_BIN_PATH="/usr/bin/"
	PLUGIN_PATH="/usr/$(get_libdir)/compiz/"
	LIBGL_NVIDIA="/usr/$(get_libdir)/opengl/xorg-x11/libGL.so.1.2"
	LIBGL_FGLRX="/usr/$(get_libdir)/opengl/xorg-x11/libGL.so.1.2"
	KWIN="$(type -p kwin)"
	METACITY="$(type -p metacity)"
	SKIP_CHECKS="yes"
	EOF

	dodoc AUTHORS ChangeLog NEWS README TODO || die "dodoc failed"

	insinto "/usr/share/applications"
	doins "${FILESDIR}/compiz.desktop" || die "Failed to install compiz.desktop"
}

pkg_preinst() {
	use gnome && gnome2_gconf_savelist
}

pkg_postinst() {
	use gnome && gnome2_gconf_install

	ewarn "If you update to x11-wm/metacity-2.24 after you install ${P},"
	ewarn "gtk-window-decorator will crash until you reinstall ${PN} again."
}

pkg_prerm() {
	use gnome && gnome2_gconf_uninstall
}
