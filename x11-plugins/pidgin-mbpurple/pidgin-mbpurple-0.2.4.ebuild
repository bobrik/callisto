# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils

DESCRIPTION=""
HOMEPAGE="http://code.google.com/p/microblog-purple/"
MY_P="${P/pidgin-/}"
SRC_URI="http://microblog-purple.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-im/pidgin"
S="$MY_P"

src_compile() {
	cd "$S"
	emake || die "emake failed"
}

src_install() {
	cd "$S"
	emake install DESTDIR=${D} || die "install failed"
}
