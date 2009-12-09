# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /usr/local/portage/media-sound/audacious/audacious-1.5.1-r1.ebuild 2009/09/27 18:47:19 szver Exp $

inherit flag-o-matic

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="http://audacious-media-player.org/"
SRC_URI="http://distfiles.atheme.org/${MY_P}.tgz
	 mirror://gentoo/gentoo_ice-xmms-0.2.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="altivec chardet nls libsamplerate session sse2 linguas_ru"

RDEPEND=">=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.14
	>=dev-libs/libmcs-0.7.1-r1
	>=dev-libs/libmowgli-0.7.0
	dev-libs/libxml2
	>=x11-libs/cairo-1.2.4
	>=x11-libs/gtk+-2.10
	>=x11-libs/pango-1.8.0
	libsamplerate? ( media-libs/libsamplerate )
	session? ( x11-libs/libSM )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9.0
	nls? ( dev-util/intltool )"

PDEPEND=">=media-plugins/audacious-plugins-1.5.1-r3"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Bug #228365, patch by Matti Hamalainen <ccr@tnsp.org>
	epatch "${FILESDIR}/${PV}-commandline-options.patch" || die

	if use linguas_ru ; then
		# russian translation changes
		tar -xjf "${FILESDIR}"/rus-trans-${PV}.tar.bz2 -C po/ || die
		# russian sings patch
		epatch "${FILESDIR}"/russian-sings-${PV}.tar.bz2 || die
	fi
}

src_compile() {
	# D-Bus is a mandatory dependency, remote control,
	# session management and some plugins depend on this.
	# Building without D-Bus is *unsupported* and a USE-flag
	# will not be added due to the bug reports that will result.
	# Bugs #197894, #199069, #207330, #208606
	econf \
		--enable-dbus \
		$(use_enable altivec) \
		$(use_enable chardet) \
		$(use_enable nls) \
		$(use_enable session sm) \
		$(use_enable sse2) \
		$(use_enable libsamplerate samplerate) \
		|| die

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README

	# Gentoo_ice skin installation; bug #109772
	insinto /usr/share/audacious/Skins/gentoo_ice
	doins "${WORKDIR}"/gentoo_ice/*
	docinto gentoo_ice
	dodoc "${WORKDIR}"/README
}

pkg_preinst() {
	# Classic1.3, Classic, Osmosis, TinyPlayer (same `text.png`)
	# Default, Ivory, Refugee, gentoo-ice (have own `text.png`)
	# themes picture russian symbols fix
	if use linguas_ru ; then
		tar -xjf "${FILESDIR}"/text-skins-russian-gentoo-"${PV}".tar.bz2 -C "${D}"/usr/share/audacious
		dosym ../Classic1.3/text.png /usr/share/audacious/Skins/Classic/text.png
		dosym ../Classic1.3/text.png /usr/share/audacious/Skins/Osmosis/text.png
		dosym ../Classic1.3/text.png /usr/share/audacious/Skins/TinyPlayer/text.png
	fi
}

pkg_postinst() {
	elog "Note that you need to recompile *all* third-party plugins for Audacious 1.5"
	elog "Plugins compiled against 1.3 or 1.4 will not be loaded."
}
