# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

DESCRIPTION="Lisp-like, general-purpose scripting language. It has all the magic of traditional Lisp but is easier to learn and use"
HOMEPAGE="http://www.newlisp.org/"
SRC_URI="http://www.newlisp.org/downloads/${P}.tgz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 amd64"

RDEPEND=">=sys-libs/readline-6.0"
DEPEND="${RDEPEND}"

src_install ()
{
    emake prefix="${D}" install || die "emake install filed"
}