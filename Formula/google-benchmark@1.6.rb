class GoogleBenchmarkAT16 < Formula
  desc "C++ microbenchmark support library"
  homepage "https://github.com/google/benchmark"
  url "https://github.com/google/benchmark/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "a9f77e6188c1cd4ebedfa7538bf5176d6acc72ead6f456919e5f464ef2f06158"
  license "Apache-2.0"
  head "https://github.com/google/benchmark.git", branch: "main"

  bottle do
    root_url "https://github.com/na-trium-144/homebrew-u22pin/releases/download/google-benchmark@1.6-1.6.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ceec2c0b54f013a61707f8025b5d97d0097b1ddd2eee0c8bd95beaa00ddee759"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08c35e776129b1f3f446ffbcd08e9e5f01c6aeb1c9d83e3a6c739ee5a133aca6"
    sha256 cellar: :any_skip_relocation, ventura:       "7887900c4f9cc8aabccf2dffc94982d7f0ead7eba0bf21681a0002645b54a025"
  end

  keg_only :versioned_formula

  depends_on "cmake@3.22" => :build

  def install
    ENV.cxx11
    system "cmake", "-DBENCHMARK_ENABLE_GTEST_TESTS=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <string>
      #include <benchmark/benchmark.h>
      static void BM_StringCreation(benchmark::State& state) {
        while (state.KeepRunning())
          std::string empty_string;
      }
      BENCHMARK(BM_StringCreation);
      BENCHMARK_MAIN();
    EOS
    flags = ["-I#{include}", "-L#{lib}", "-lbenchmark", "-pthread"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end
