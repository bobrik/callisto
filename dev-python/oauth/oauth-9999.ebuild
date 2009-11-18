# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils subversion

ESVN_REPO_URI="http://oauth.googlecode.com/svn/code/python/"

DESCRIPTION="Python library for OAuth"
HOMEPAGE="http://code.google.com/p/oauth"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND="dev-lang/python"
RDEPEND="${DEPEND}"

