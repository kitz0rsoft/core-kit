# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/8fcba4bacadef73abdb49a64788c7b3f8e918667 -> skim-0.17.2-8fcba4b.tar.gz
https://distfiles.macaronios.org/f0/5e/05/f05e054771515dac81cff6fb980393ca4b768c9f59fb9b8175132dab1dcf902669153dac046623b1c52ea6badeb82bac974125e6d679363f60c3c4233052c9e3 -> skim-0.17.2-funtoo-crates-bundle-d719b26ba893b9c20703d501e9f2d1fb5057ca6fdbf7d3609006a090f0dea9368e75c9bd591b5d8b658085a61ded1dbd764c0bfe0f7e210bc2d413cf4a8bae4b.tar.gz"

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