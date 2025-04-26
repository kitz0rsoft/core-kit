# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/e93e65c35205290f8e1d0ed833ac6c8016d7a818 -> skim-0.16.2-e93e65c.tar.gz
https://regen.mordor/5e/e2/c0/5ee2c009d303fb289a7d3f5595b20e34dd9a052f9f942580c393ef963d3a6ab67ebb2cb4d5c0ed66eeab020321ae31ce6b8db936b4fe91ea367e769dede34a8f -> skim-0.16.2-funtoo-crates-bundle-86260cac512dae6f8b5c61cd0451846abfc961f847f307b779450d3fb1ff1fa5922a6fcc370c0ed735c73222e3c4180546410ee394826330b75db669b208bb69.tar.gz"

LICENSE="Apache-2.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="*"
IUSE="tmux vim"

RDEPEND="
	tmux? ( app-misc/tmux )
	vim? ( || ( app-editors/vim app-editors/gvim ) )
"
BDEPEND="virtual/rust"

QA_FLAGS_IGNORED="usr/bin/sk"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/skim-rs-skim-* ${S} || die
}

src_install() {
	# prevent cargo_src_install() blowing up on man installation
	mv man manpages || die

	cargo_src_install --path skim
	dodoc CHANGELOG.md README.md
	doman manpages/man1/*

	use tmux && dobin bin/sk-tmux

	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins plugin/skim.vim
	fi

	# install bash/zsh completion and keybindings
	# since provided completions override a lot of commands, install to /usr/share
	insinto /usr/share/${PN}
	doins shell/{*.bash,*.zsh}
}