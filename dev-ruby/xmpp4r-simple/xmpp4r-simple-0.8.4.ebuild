# Copyright 2008 Ivan Babrou <ibobrik@gmail.com>
# Distributed under the terms of the GNU General Public License v2

inherit ruby gems

DESCRIPTION="Simplification of the Jabber functionality exposed by xmpp4r."
HOMEPAGE="http://xmpp4r-simple.rubyforge.org/"
SRC_URI="http://xmpp4r-simple.googlecode.com/files/${P}.gem"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

DEPEND=">=dev-lang/ruby-1.8
	dev-ruby/xmpp4r"