# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Pidgin plugin for vk.com social network"
HOMEPAGE="http://http://code.google.com/p/pidgin-vk/"

SRC_URI="
	amd64? ( http://pidgin-vk.googlecode.com/files/libvk${PV}.linux_x86_64.tar.gz )
	x86? ( http://pidgin-vk.googlecode.com/files/libvk${PV}.linux.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-im/pidgin"

src_install() {
	insinto "/usr/lib/purple-2"
	doins "usr/lib/purple-2/libvk.so"
	for i in 16  22  48; do
		insinto "/usr/share/pixmaps/pidgin/protocols/$i"
		doins "usr/share/pixmaps/pidgin/protocols/$i/vk.png"
	done
}
