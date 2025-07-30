# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/bc3c4a0ad38ad94db891f4d0cbf01ecda5ed650e -> skim-0.20.3-bc3c4a0.tar.gz
https://regen.mordor/ca/b0/df/cab0df9f30174cb1b3e062c5df9cf1932756b55e93bab03731a516898110b818bcc2bd5e859e8216110f355da02c41269f2971f186dc50562561a28a97faf368 -> skim-0.20.3-funtoo-crates-bundle-6d164d47907971550ffe492ff4d6279a6c7b336920dfff3bbd060820407d10fd919b2f1116b0c8794fd842062631e62e6c2edcbc6e7278bdb823c85a4f51f2a8.tar.gz"

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