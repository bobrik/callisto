# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4
DESCRIPTION="QStarDict is a StarDict clone written with using Qt"
HOMEPAGE="http://qstardict.ylsoftware.com/"
SRC_URI="http://qstardict.ylsoftware.com/files/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ia64"
IUSE="dbus nls"
RDEPEND=">=x11-libs/qt-core-4.4.2:4
	>=x11-libs/qt-gui-4.4.2:4
	dbus? ( >=x11-libs/qt-dbus-4.4.2:4 )
	#plasma? ( >=kde-base/plasma-workspace-4.2.0 )
	>=dev-libs/glib-2.0"
DEPEND="${RDEPEND}"
PROVIDE="virtual/stardict"

src_compile() {
	QMAKE_FLAGS=""
	if ! use dbus; then
		QMAKE_FLAGS+="NO_DBUS=1 "
	fi
	if ! use nls; then
		QMAKE_FLAGS+="NO_TRANSLATIONS=1 "
	fi
	eqmake4 $QMAKE_FLAGS || die "qmake failed"
	emake || die "emake failed"
	#if use plasma; then
	#	einfo "Creating plasmoid"
	#	cd $WORKDIR/$P/kdeplasma
	#	cmake -DCMAKE_INSTALL_PREFIX=/usr || die "cmake for plasmoid failed"
	#	make | die "making plasmoid failed"
	#	cd -
	#fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install filed"
	#if use plasma; then
	#	cd $WORKDIR/$P/kdeplasma
	#	make install
	#	cd -
	#fi
}

