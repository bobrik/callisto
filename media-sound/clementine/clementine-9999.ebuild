# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="2"
inherit cmake-utils gnome2-utils subversion

DESCRIPTION="A modern music player and library organizer based on Amarok 1.4 and Qt4"
HOMEPAGE="http://code.google.com/p/clementine-player/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

ESVN_REPO_URI="http://clementine-player.googlecode.com/svn/trunk"

IUSE=""

RDEPEND="x11-libs/qt-gui:4
    x11-libs/qt-sql:4[sqlite]
    x11-libs/qt-opengl:4
    media-libs/liblastfm
    x11-libs/libnotify
    media-libs/xine-lib
    media-libs/taglib
    dev-libs/glib:2"
DEPEND="${RDEPEND}
    >=dev-libs/boost-1.41
    dev-util/pkgconfig"

DOCS="Changelog TODO"

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
