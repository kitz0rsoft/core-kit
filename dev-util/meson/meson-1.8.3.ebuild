# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit bash-completion-r1 distutils-r1 toolchain-funcs

DESCRIPTION=""
HOMEPAGE="https://mesonbuild.com/"
SRC_URI="https://github.com/mesonbuild/meson/tarball/872ae45f7f088524676eccf26959f0fd6dfa1b13 -> meson-1.8.3-872ae45.tar.gz"
LICENSE="Apache-2.0"

KEYWORDS="*"

SLOT="0"

S="${WORKDIR}/mesonbuild-meson-872ae45"

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/vim/vimfiles
	doins -r data/syntax-highlighting/vim/{ftdetect,indent,syntax}
	insinto /usr/share/zsh/site-functions
	doins data/shell-completions/zsh/_meson
}