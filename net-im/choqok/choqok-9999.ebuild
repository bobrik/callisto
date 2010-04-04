# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

KMNAME="extragear/network"
KMMODULE="choqok"
inherit kde4-base

DEPEND=">=dev-libs/qjson-0.7.0"
RDEPEND="${DEPEND}"

DESCRIPTION="A Free/Open Source micro-blogging client for K Desktop Environment."
HOMEPAGE="http://choqok.gnufolks.org/"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"
