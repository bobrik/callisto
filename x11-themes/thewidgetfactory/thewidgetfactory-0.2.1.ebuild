# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A showcase for GTK+ widgets"
HOMEPAGE="http://www.stellingwerff.com/?page_id=10"
SRC_URI="http://www.stellingwerff.com/TheWidgetFactory/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE=""

RDEPEND="x11-libs/gtk+:2"

DEPEND="${RDEPEND}"

src_install() {
	dobin src/twf || die "dobin failed"
	make_desktop_entry "/usr/bin/twf" "The Widget Factory" "gnome-about-logo.png" "Application;Utility;Development;GTK;" || die "make_desktop_entry failed"
}
