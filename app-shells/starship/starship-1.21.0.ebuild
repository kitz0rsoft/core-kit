# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="The minimal, blazing-fast, and infinitely customizable prompt for any shell"
HOMEPAGE="https://github.com/starship/starship"
SRC_URI="https://github.com/starship/starship/tarball/2125e432ab17bc64305a5e4cdad43be4abfc0313 -> starship-1.21.0-2125e43.tar.gz
https://regen.mordor/c6/20/fc/c620fc615a0ab9a85a5f22e386460148c5ab84093ab3d119a1e18da6106aaf1c4ed1bf1f01d4adafbb4841b149fa9393779789776581f9edbaf4e2d2258d6c41 -> starship-1.21.0-funtoo-crates-bundle-a9e2ac30872094deb5966bef4edd50a16b788faa0e1ea5eecb76e8da3f6c6a1db5fc325e3164fad14b3a619c459a6f4cd38bf7596b1daef0cdd12ee245d6ca1e.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="*"
IUSE="libressl"

DEPEND="
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/rust"

DOCS="docs/README.md"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/starship-starship-* ${S} || die
}

src_install() {
	dobin target/release/${PN}
	default
}

pkg_postinst() {
	echo
	elog "Thanks for installing starship."
	elog "For better experience, it's suggested to install some Powerline font."
	elog "You can get some from https://github.com/powerline/fonts"
	echo
}