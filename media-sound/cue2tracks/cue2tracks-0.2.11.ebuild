# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/cue2tracks/cue2tracks-0.2.11.ebuild 2010/03/30 16:59:38 xxx Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Shell script to split audio image with .cue"
HOMEPAGE="http://www.ylsoftware.com/storage/files/14/page/0"
SRC_URI="http://www.ylsoftware.com/files/cue2tracks-0.2.11.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="id3tag"

RDEPEND=">=media-sound/shntool-3.0.0
		app-shells/bash
		app-cdr/cuetools
		media-libs/flac
		media-sound/lame
		id3tag? ( media-libs/id3lib )
		!id3tag? ( media-sound/id3v2 )"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-main.patch.bz2" || die "epatch FILED!!!"
	if use id3tag ; then
		epatch "${FILESDIR}/${P}-id3tag.patch.bz2" || die "epatch FILED!!!"
		epatch "${FILESDIR}/${P}-id3tag-genre-list.patch.bz2" || die "epatch FILED!!!"
	fi
}

src_install() {
	dobin "${PN}" || die
	dodoc AUTHORS INSTALL ChangeLog README TODO
	if use id3tag ; then
		insinto	"/usr/share/doc/${P}"
		doins genres-list
	fi
}

pkg_postinst() {
	echo ""
	einfo 'To get help about usage run "$ cue2tracks -h"'
	echo ""
}
