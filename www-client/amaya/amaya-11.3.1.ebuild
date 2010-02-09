# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: www-client/amaya/amaya-11.3.1.ebuild 2010/01/24 02:00:09 szver Exp $

EAPI="2"

inherit libtool eutils

S="${WORKDIR}/Amaya${PV}/Amaya/linux"

DESCRIPTION="The W3C Web-Browser"
HOMEPAGE="http://www.w3.org/Amaya/"
SRC_URI="http://www.w3.org/Amaya/Distribution/${PN}-sources-${PV}.tgz"
#SRC_URI="http://wam.inrialpes.fr/software/amaya/${PN}-fullsrc-${PV/_/-}3.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl svg +xml webdav"

DEPEND="
				media-libs/raptor
				svg? ( gnome-base/librsvg )
				opengl? ( virtual/opengl )"
				#~ x11-libs/wxGTK:2.8
				#~ net-libs/libwww
RDEPEND="${DEPEND}"

src_prepare() {
		use opengl && rm -rf "${WORKDIR}/Amaya${PV}/Mesa/"
		#~ rm -rf "${WORKDIR}/wxWidgets"
		#~ rm -rf "${WORKDIR}/libwww"
		rm -rf "${WORKDIR}/Amaya${PV}/redland"
		rm -rf "${WORKDIR}/Amaya${PV}/freetype"
}

src_configure() {
    local myconf
    mkdir ${S}
    cd ${S}

    #~ use opengl && myconf="${myconf} --with-gl"
    #~ use debug && myconf="${myconf} --with-debug"
    #~ use svg || myconf="${myconf} --disable-svg"
    #~ use xml || myconf="${myconf} --disable-generic-xml"

    ../configure \
        --prefix=/usr \
        --host=${CHOST} \
        --mandir=/usr/share/man\
        --infodir=/usr/share/info \
        --datadir=/usr/share \
        --sysconfdir=/etc \
        --localstatedir=/var/lib \
        --docdir=/usr/share/doc/${PF} \
        --enable-system-raptor \
        $(use_enable svg) \
        $(use_enable xml generic-xml) \
        $(use_with opengl gl) \
        $(use_with opengl mesa)

        #~$(use_with webdav dav)
        #~ --enable-system-libwww \
        #~ --enable-system-raptor \
        #~ --enable-system-wx \
#        --bindir=/usr/bin \
#        --sbindir=/usr/sbin \
#        --libexecdir=/usr/libexec \
#        --libdir=/usr/lib \
#        --includedir=/usr/include \


}

src_compile() {
#	make CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS" || die
	emake -j1 CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS" || die
}

src_install () {
		dodir /usr
		einstall || die
		#make install DESTDIR=${D} || die
		./script_install_gnomekde . ${D}/usr/share /usr || die

		rm ${D}/usr/bin/amaya
		rm ${D}/usr/bin/print
		dosym /usr/Amaya/wx/bin/amaya /usr/bin/amaya
		dosym /usr/Amaya/wx/bin/print /usr/bin/print

		domenu share/applications/amaya.desktop
		newicon ${WORKDIR}/Amaya${PV}/Amaya/resources/bundle/logo.png amaya.png
}
