# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gwibber/gwibber-0.7.ebuild,v 1.2 2009/05/20 15:19:08 arfrever Exp $

NEED_PYTHON="2.5"

inherit distutils

DESCRIPTION="Gwibber is an open source microblogging client for GNOME developed with Python and GTK."
HOMEPAGE="https://launchpad.net/gwibber"
SRC_URI="https://launchpad.net/ubuntu/karmic/+source/gwibber/0.9.2~bzr263-0ubuntu3/+files/gwibber_0.9.2~bzr263.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/dbus-python-0.80.2
	>=dev-python/pywebkitgtk-1.0.1
	>=dev-python/notify-python-0.1.1
	>=dev-python/simplejson-1.9.1
	>=dev-python/egenix-mx-base-3.0.0
	>=dev-python/feedparser-4.1
	>=dev-python/pygtk-2.10.4
	>=dev-python/gconf-python-2.18.0
	>=dev-python/pyxdg-0.15
	>=dev-python/imaging-1.1.6
	dev-python/python-distutils-extra"
DEPEND=""

S="${WORKDIR}/gwibber-0.9.2~bzr263"
