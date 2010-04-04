# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="2"
inherit eutils qt4-r2 git

DESCRIPTION="Lightweigh crossplatform application for notes management"
HOMEPAGE="http://znotes.sourceforge.net/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE="doc +singleinstance +format_todo +format_xml"

EGIT_REPO_URI="git://github.com/proton/zNotes.git"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_configure() {
	lrelease znotes.pro || die "lrelease failed"
	use singleinstance || myconf="${myconf} CONFIG+=without_single_inst"
	use format_todo || myconf="${myconf} CONFIG+=without_todo_format"
	use format_xml || myconf="${myconf} CONFIG+=without_xml_format"
	eqmake4 znotes.pro "${myconf}" || die "configure failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake failed"
	use doc && dodoc CHANGELOG LICENSE INSTALL THANKS
}