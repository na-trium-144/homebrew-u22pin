class EigenAT34 < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  url "https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz"
  sha256 "8586084f71f9bde545ee7fa6d00288b264a2b7ac3607b974e54d13e7162c1c72"
  license "MPL-2.0"
  revision 1
  head "https://gitlab.com/libeigen/eigen.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    root_url "https://github.com/na-trium-144/homebrew-u22pin/releases/download/eigen@3.4-3.4.0_1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9bb1e9a88a8e9177107fe634d057e54830d2f8cf71c4da66788739e31e7b915"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57bf3ca9bad31bdf349c44e43833bc1ac5e143f3daecf78717914bbd4d2ab272"
    sha256 cellar: :any_skip_relocation, ventura:       "60d04c56543316ee5fd38f0dc1a66e23e51973a31199913b69f37b9f7692696f"
  end
  keg_only :versioned_formula

  depends_on "cmake@3.22" => :build

  def install
    system "cmake", "-S", ".", "-B", "eigen-build", "-Dpkg_config_libdir=#{lib}", *std_cmake_args
    system "cmake", "--install", "eigen-build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <Eigen/Dense>
      using Eigen::MatrixXd;
      int main()
      {
        MatrixXd m(2,2);
        m(0,0) = 3;
        m(1,0) = 2.5;
        m(0,1) = -1;
        m(1,1) = m(1,0) + m(0,1);
        std::cout << m << std::endl;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}/eigen3", "-o", "test"
    assert_equal %w[3 -1 2.5 1.5], shell_output("./test").split
  end
end
