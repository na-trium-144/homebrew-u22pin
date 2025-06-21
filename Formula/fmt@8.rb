class FmtAT8 < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/refs/tags/8.1.1.tar.gz"
  sha256 "3d794d3cf67633b34b2771eb9f073bde87e846e0d395d254df7b211ef1ec7346"
  license "MIT"
  revision 1
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    root_url "https://github.com/na-trium-144/homebrew-u22pin/releases/download/fmt@8-8.1.1_1"
    sha256 cellar: :any, arm64_sequoia: "a99cfcc74e330eed1cd105ba5fb3aa11ce7736fe3b02cef5ad6569cb8c1e6ec8"
    sha256 cellar: :any, arm64_sonoma:  "82649df78a8572688105bd1a2717db85fe6f7181572f89df09e48a7a5bc24daa"
    sha256 cellar: :any, ventura:       "a4fafcd9e0972e988dd628d5689279017048ef015ad481a6003406fa2854236b"
  end

  keg_only :versioned_formula

  depends_on "cmake@3.22" => :build

  # Fix Watchman build.
  # https://github.com/fmtlib/fmt/issues/2717
  patch do
    url "https://github.com/fmtlib/fmt/commit/8f8a1a02d5c5cb967d240feee3ffac00d66f22a2.patch?full_index=1"
    sha256 "ac5d7a8f9eabd40e34f21b1e0034fbc4147008f13b7bf2314131239fb3a7bdab"
  end

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "make"
    lib.install "libfmt.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
