class GrpcAT130 < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
    tag:      "v1.30.2",
    revision: "de6defa6fff08de20e36f9168f5b277e292daf46",
    shallow:  false
  license "Apache-2.0"
  head "https://github.com/grpc/grpc.git", branch: "master"

  livecheck do
    url "https://github.com/grpc/grpc/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/na-trium-144/homebrew-u22pin/releases/download/grpc@1.30-1.30.2"
    sha256 arm64_sequoia: "2add60c19770b7d0105f6924c68936aef226a0a85e91708fd9a67989f9cb22de"
    sha256 arm64_sonoma:  "ff4a2cef1d86c84dbcc144762f5c8984b89759bc78ebe7b7fc10aac56be9a294"
    sha256 ventura:       "7de26ef47d43a02a0a481d02ae3dbe458173fa2f19c3f903b01c1f4e839cc693"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl"
  depends_on "protobuf@3.12"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/refs/tags/release-1.10.0.tar.gz"
    sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
  end

  def install
    system "make", "install", "prefix=#{prefix}", "CFLAGS=-Wno-implicit-function-declaration"
    system "make", "install-plugins", "prefix=#{prefix}"

    (buildpath/"third_party/googletest").install resource("gtest")
    system "make", "grpc_cli", "prefix=#{prefix}"
    bin.install "bins/opt/grpc_cli"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <grpc/grpc.h>
      int main() {
        grpc_init();
        grpc_shutdown();
        return GRPC_STATUS_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lgrpc", "-o", "test"
    system "./test"
  end
end
