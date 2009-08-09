# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit kde4-base

DESCRIPTION="Kde4 plasmoid for QStarDict dictionary program"
HOMEPAGE="http://qstardict.ylsoftware.com/"
SRC_URI="http://qstardict.ylsoftware.com/files/qstardict-${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

RDEPEND="
	>=kde-base/plasma-workspace-${KDE_MINIMAL}
	~app-dicts/qstardict-${PV}
"

S=${PORTAGE_BUILDDIR}/work/qstardict-${PV}/kdeplasma
