# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit autotools git

EGIT_REPO_URI="git://deadbeef.git.sourceforge.net/gitroot/deadbeef/deadbeef"

DESCRIPTION="Lightweight audio player for GNU/Linux systems"
HOMEPAGE="http://deadbeef.sourceforge.net/"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="libnotify"

RDEPEND="media-libs/libvorbis
	   media-libs/libmad
	   media-libs/libogg
	   x11-libs/gtk+:2
	   media-libs/libsamplerate
	   media-libs/alsa-lib
	   libnotify? ( x11-libs/libnotify )"
DEPEND=""

src_configure() {
	./autogen.sh || die "autogen failed"
	econf $(use_enable libnotify) || die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}