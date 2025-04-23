# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to run commands against Kubernetes clusters"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/tarball/e1680af9f4a50ba886ed5f5221b6cf8bd80ee6cf -> kubernetes-1.32.4-e1680af.tar.gz
https://regen.mordor/7e/99/c6/7e99c69e130dbb1b739e11f06f077e7fbcd315d2c23ac14d267791da47c15b4d0270f64041e1119889962ba8918a82524a1b5a8911184a7923684c2334a612ca -> kubectl-1.32.4-funtoo-go-bundle-0b09881a86ff7f5ceeace8ae5bc77a1e6f83e10b310e45678a11be9b5b07ab380dba45e77b2bc411c44f7351c0a9a9fa39f67a69683ce38a8e82f45ec2ee5487.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="hardened"

DEPEND="!sys-cluster/kubernetes"
BDEPEND=">=dev-lang/go-1.21"

RESTRICT+=" test"

src_unpack() {
	default
	rm -rf ${S}
	mv ${WORKDIR}/kubernetes-kubernetes-* ${S} || die
}

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
	FORCE_HOST_GO=yes \
		emake -j1 GOFLAGS="" GOLDFLAGS="" LDFLAGS="" WHAT=cmd/${PN}
}

src_install() {
	dobin _output/bin/${PN}
	_output/bin/${PN} completion bash > ${PN}.bash || die
	_output/bin/${PN} completion zsh > ${PN}.zsh || die
	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}
}