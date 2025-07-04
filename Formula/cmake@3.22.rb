class CmakeAT322 < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.22.3/cmake-3.22.3.tar.gz"
  # mirror "http://fresh-center.net/linux/misc/cmake-3.22.3.tar.gz"
  # mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.22.3.tar.gz"
  sha256 "9f8469166f94553b6978a16ee29227ec49a2eb5ceb608275dec40d8ae0d1b5a0"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/na-trium-144/homebrew-u22pin/releases/download/cmake@3.22-3.22.3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd8467a4d3204b3bd0b335e13f7d6245c0c7246d28702b582667ba447dbb122c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c5b53acba76a23f9c0e7edc0157ef6babf3be376f74139b2dab736dc651b465"
    sha256 cellar: :any_skip_relocation, ventura:       "234c79077a572d943edd8dfc370bcbb33db29fe07a331eccba7ac9fac2f6f04d"
  end

  keg_only :versioned_formula

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"

    # Remove deprecated and unusable binary
    # https://gitlab.kitware.com/cmake/cmake/-/issues/20235
    (share/"cmake/Modules/Internal/CPack/CPack.OSXScriptLauncher.in").unlink
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end
