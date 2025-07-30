# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fly through your shell history. Great Scott!"
HOMEPAGE="https://github.com/cantino/mcfly"
SRC_URI="https://github.com/cantino/mcfly/tarball/4e96d87be5722881cff02ebf574190c85f998cf1 -> mcfly-0.9.3-4e96d87.tar.gz
https://regen.mordor/55/72/e6/5572e6f66f64a6f260297ab58f5643720721bfa30b0f5054070ff09aa1a2b5848cedde576e03eeb9df3d91d78024e16d22c0d894093cff23e4ef40e4b27c8c16 -> mcfly-0.9.3-funtoo-crates-bundle-9a392e00cb8de4c08a4a52f33f4573a11891bf1e7394a8ec36bbd2f2610b55360416c5e07f0828394d9caf48f2616e924afda1a296525eb0875f1ee42d480b92.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 MIT Unlicense"
SLOT="0"
KEYWORDS="*"

DEPEND="dev-db/sqlite:3"
RDEPEND="${DEPEND}"
BDEPEND="virtual/rust"

QA_FLAGS_IGNORED="/usr/bin/mcfly"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/cantino-mcfly-* ${S} || die
}

src_install() {
	cargo_src_install

	insinto "/usr/share/${PN}"
	doins "${PN}".{bash,fish,zsh}

	einstalldocs
}

pkg_postinst() {

	elog "To start using ${PN}, add the following to your shell:"
	elog
	elog "~/.bashrc"
	local p="${EPREFIX}/usr/share/${PN}/${PN}.bash"
	elog "[[ -f ${p} ]] && source ${p}"
	elog
	elog "~/.config/fish/config.fish"
	local p="${EPREFIX}/usr/share/${PN}/${PN}.fish"
	elog "if test -r ${p}"
	elog "    source ${p}"
	elog "    mcfly_key_bindings"
	elog
	elog "~/.zsh"
	local p="${EPREFIX}/usr/share/${PN}/${PN}.zsh"
	elog "[[ -f ${p} ]] && source ${p}"
}