class SpdlogAT19 < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "6fff9215f5cb81760be4cc16d033526d1080427d236e86d70bb02994f85e3d38"
  license "MIT"
  head "https://github.com/gabime/spdlog.git", branch: "v1.x"

  bottle do
    root_url "https://github.com/na-trium-144/homebrew-u22pin/releases/download/spdlog@1.9-1.9.2"
    sha256 cellar: :any, arm64_sequoia: "6a7c01b46c1225ef309c24318ff1c2619472131f1d4b612359503a0ae896d9ae"
    sha256 cellar: :any, arm64_sonoma:  "e5c4b781f77e6de85e0eeada1e31d1cbe39221ee8274f5b87833a4943265072a"
    sha256 cellar: :any, ventura:       "811b3d657536e332e87b73f2210161d6d558b3489e0300ee126e73fee64826b6"
  end

  keg_only :versioned_formula

  depends_on "cmake@3.22" => :build
  depends_on "fmt@8"

  def install
    ENV.cxx11

    inreplace "include/spdlog/tweakme.h", "// #define SPDLOG_FMT_EXTERNAL", <<~EOS
      #ifndef SPDLOG_FMT_EXTERNAL
      #define SPDLOG_FMT_EXTERNAL
      #endif
    EOS

    mkdir "spdlog-build" do
      args = std_cmake_args + %W[
        -Dpkg_config_libdir=#{lib}
        -DSPDLOG_BUILD_BENCH=OFF
        -DSPDLOG_BUILD_TESTS=OFF
        -DSPDLOG_FMT_EXTERNAL=ON
      ]
      system "cmake", "..", "-DSPDLOG_BUILD_SHARED=ON", *args
      system "make", "install"
      system "make", "clean"
      system "cmake", "..", "-DSPDLOG_BUILD_SHARED=OFF", *args
      system "make"
      lib.install "libspdlog.a"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "spdlog/sinks/basic_file_sink.h"
      #include <iostream>
      #include <memory>
      int main()
      {
        try {
          auto console = spdlog::basic_logger_mt("basic_logger", "#{testpath}/basic-log.txt");
          console->info("Test");
        }
        catch (const spdlog::spdlog_ex &ex)
        {
          std::cout << "Log init failed: " << ex.what() << std::endl;
          return 1;
        }
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{Formula["fmt@8"].opt_include}", "-I#{include}",
"-L#{Formula["fmt@8"].opt_lib}", "-lfmt", "-o", "test"
    system "./test"
    assert_path_exists testpath/"basic-log.txt"
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
