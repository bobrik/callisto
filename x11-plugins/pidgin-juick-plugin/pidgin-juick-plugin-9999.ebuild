# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

DESCRIPTION="Plugin for convenient use of russian mikroblogging service juick"
HOMEPAGE="http://github.com/mad/pidgin-juick-plugin/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

EGIT_REPO_URI="git://github.com/mad/pidgin-juick-plugin.git"

RDEPEND="net-im/pidgin"

DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/lib/purple-2/
	doins juick.so || die "doins failed"
}
