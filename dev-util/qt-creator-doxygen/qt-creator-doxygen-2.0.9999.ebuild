# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="2"
inherit subversion

DESCRIPTION="Qt Creator plugin to automatically insert and build Doxygen doxumentation"
HOMEPAGE="http://dev.kofee.org/QtCreator-Doxygen/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86 amd64"

ESVN_REPO_URI="http://svn.kofee.org/svn/qtcreator-doxygen/trunk"

QT_CREATOR_DIRNAME="qt-creator-2.0.0-src"
QT_CREATOR_FILENAME="${QT_CREATOR_DIRNAME}.tar.gz"

SRC_URI="http://get.qt.nokia.com/qtcreator/${QT_CREATOR_FILENAME}"

IUSE=""

RDEPEND=">=dev-util/qt-creator-2.0.0"
DEPEND="${RDEPEND}"

src_compile() {
    if [ ! -f "${DISTDIR}/${QT_CREATOR_FILENAME}" ]; then
        ${FETCHCOMMAND} ${SRC_URL}
    fi

    tar zxf "${DISTDIR}/${QT_CREATOR_FILENAME}" -C ${WORKDIR}

	sed -ri "s|^(unix:QTC_SOURCE_DIR = ).*|\1${WORKDIR}/${QT_CREATOR_DIRNAME}|" doxygen.pro
	sed -ri "s|^(unix:QTC_BUILD_DIR = ).*|\1${D}|" doxygen.pro
	sed -ri "s|-L/home/kofee/Dev/Qt/qtcreator-2.0.0-alpha1-src/lib/qtcreator/|-L/usr/lib/qtcreator|" doxygen.pro
	sed -ri "s|-L/home/kofee/Dev/Qt/qt-creator-2.0.0-alpha1-src/lib/qtcreator/plugins/Nokia/|-L/usr/lib/qtcreator/plugins/Nokia|" doxygen.pro

	qmake || die
	make || die
}

src_install() {
    dodir "lib/qtcreator/plugins/Kofee"
    INSTALL_ROOT="${D}" make install || die
}