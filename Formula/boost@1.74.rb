class BoostAT174 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://downloads.sourceforge.net/project/boost/boost/1.74.0/boost_1_74_0.tar.bz2"
  # url "https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.tar.bz2"
  # mirror "https://dl.bintray.com/homebrew/mirror/boost_1_74_0.tar.bz2"
  sha256 "83bfc1507731a0906e387fc28b7ef5417d591429e51e788417fe9ff025e116b1"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    url "https://www.boost.org/feed/downloads.rss"
    regex(/>Version v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    root_url "https://github.com/na-trium-144/homebrew-u22pin/releases/download/boost@1.74-1.74.0"
    sha256 cellar: :any, arm64_sequoia: "1582c3b2af8934180a98bfc5207f68f54ad73ff01afe52d39757b70081142146"
    sha256 cellar: :any, arm64_sonoma:  "f4263676333952dadb7bd0327bf34e18529da90ab68116222893f91c65497b01"
    sha256 cellar: :any, ventura:       "469bfe04a52db79cf35400c8cf1d6d0c31ffa5c40fa56c19be33f1471ba66175"
  end

  keg_only :versioned_formula

  depends_on "icu4c"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Fix build on 64-bit arm
  patch do
    url "https://github.com/boostorg/build/commit/456be0b7ecca065fbccf380c2f51e0985e608ba0.patch?full_index=1"
    sha256 "e7a78145452fc145ea5d6e5f61e72df7dcab3a6eebb2cade6b4cfae815687f3a"
    directory "tools/build"
  end

  def install
    # Force boost to compile with the desired compiler
    open("user-config.jam", "a") do |file|
      if OS.mac?
        file.write "using darwin : : #{ENV.cxx} ;\n"
      else
        file.write "using gcc : : #{ENV.cxx} ;\n"
      end
    end

    # libdir should be set by --prefix but isn't
    icu4c_prefix = Formula["icu4c"].opt_prefix
    bootstrap_args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      --with-icu=#{icu4c_prefix}
    ]

    # Handle libraries that will not be built.
    without_libraries = ["python", "mpi"]

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc

    bootstrap_args << "--without-libraries=#{without_libraries.join(",")}"

    # layout should be synchronized with boost-python and boost-mpi
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged-1.66
      --user-config=user-config.jam
      -sNO_LZMA=1
      -sNO_ZSTD=1
      install
      threading=multi,single
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    args << "cxxflags=-Wno-enum-constexpr-conversion" if ENV.compiler == :clang

    system "./bootstrap.sh", *bootstrap_args
    system "./b2", "headers"
    system "./b2", *args
  end

  # def caveats
  #   s = ""
  #   # ENV.compiler doesn't exist in caveats. Check library availability
  #   # instead.
  #   if Dir["#{lib}/libboost_log*"].empty?
  #     s += <<~EOS
  #       Building of Boost.Log is disabled because it requires newer GCC or Clang.
  #     EOS
  #   end

  #   s
  # end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/algorithm/string.hpp>
      #include <string>
      #include <vector>
      #include <assert.h>
      using namespace boost::algorithm;
      using namespace std;

      int main()
      {
        string str("a,b");
        vector<string> strVec;
        split(strVec, str, is_any_of(","));
        assert(strVec.size()==2);
        assert(strVec[0]=="a");
        assert(strVec[1]=="b");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}"
    system "./test"
  end
end
