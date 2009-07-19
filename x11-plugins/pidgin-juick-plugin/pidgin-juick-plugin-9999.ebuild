# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

DESCRIPTION="Plugin for convenient use of russian mikroblogging service juick"
HOMEPAGE="http://github.com/mad/pidgin-juick-plugin/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

EGIT_REPO_URI="git://github.com/mad/pidgin-juick-plugin.git"

RDEPEND="net-im/pidgin"

DEPEND="${RDEPEND}"

src_compile() {
	emake all || die "all"
}

src_install() {
	emake DESTDIR="${D}" install || die
}