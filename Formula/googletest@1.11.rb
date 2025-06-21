class GoogletestAT111 < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/refs/tags/release-1.11.0.tar.gz"
  sha256 "b4870bf121ff7795ba20d20bcdd8627b8e088f2d1dab299a031c1034eddc93d5"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/na-trium-144/homebrew-u22pin/releases/download/googletest@1.11-1.11.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a5ea2969a939dd06cf03bc6ec33b140af847e10cb1310bd51aa5927c08ce97e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b8cd54a88aa541febb8f09cce8703e1ec1d24c7a19b3daf81527ad3f90bcc45"
    sha256 cellar: :any_skip_relocation, ventura:       "56ec50352e237ec48739c189ee794810b8634bd6f3996b1ca405b7db5d2359b3"
  end

  keg_only :versioned_formula

  depends_on "cmake@3.22" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # for use case like `#include "googletest/googletest/src/gtest-all.cc"`
    (include/"googlemock/googlemock/src").install Dir["googlemock/src/*"]
    (include/"googletest/googletest/src").install Dir["googletest/src/*"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtest/gtest.h>
      #include <gtest/gtest-death-test.h>

      TEST(Simple, Boolean)
      {
        ASSERT_TRUE(true);
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lgtest", "-lgtest_main", "-pthread",
"-o", "test"
    system "./test"
  end
end
