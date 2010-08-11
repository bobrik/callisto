# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /usr/local/portage/app-text/ocre/ocre-0.034.ebuild v0.01 2010/08/12 02:20:20 xxx Exp $

EAPI="2"

inherit autotools

DESCRIPTION="o.c.r. easy program"
HOMEPAGE="http://lem.eui.upm.es/ocre.html"
LICENSE="GPL-3"
MY_PV="${PV/./_}"
SRC_URI="ftp://lem.eui.upm.es/pub/ocre/${PN}_v${MY_PV}.tgz"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="x11-libs/gtk+:2
		app-text/aspell
"

S="${WORKDIR}/${P}/ocre"

#~ src_unpack() {
	#~ unpack ${A}
	#~ cd "${S}"
#~ }

src_prepare() {
	# add CFLAGS
	sed -e "/^CFLAGS =/ s/$/ ${CFLAGS}/" -i.bak1 Makefile
}

src_compile() {
	emake depend
	emake ocre
}

src_install() {
	emake DESTDIR="${D}/usr" install installman
	tar xvf "ocre-decsWood-0.034.tgz" -C "${D}/usr/share/ocre"
}
