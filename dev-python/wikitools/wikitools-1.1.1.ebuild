# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils


DESCRIPTION="Python package for interacting with a MediaWiki wiki"
HOMEPAGE="http://code.google.com/p/python-wikitools"
LICENSE="GPL-3"
SRC_URI="http://pypi.python.org/packages/source/w/${PN}/${P}.tar.gz"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND="dev-lang/python"
RDEPEND="${DEPEND}"

