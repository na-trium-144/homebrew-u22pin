class ProtobufAT312 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.12.4/protobuf-all-3.12.4.tar.gz"
  sha256 "e7bf41873d1a87c05c2b0a6197f4445c6ea3469ce0165ff14de2df8b34262530"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/na-trium-144/homebrew-u22pin/releases/download/protobuf@3.12-3.12.4"
    sha256 cellar: :any, arm64_sequoia: "6520b95737f140149ab90030c2121fd0da5d9f787cfb32040b1b4df20037062d"
    sha256 cellar: :any, arm64_sonoma:  "e9b5bac80fd3fba05854ad946db3616f67f9cf7cab4640df1591fc42d921de4c"
    sha256 cellar: :any, ventura:       "c1e9ab4d85713ea116b95253588cc583f314b47b47d5ef8ad182f45cc90c9964"
  end

  head do
    url "https://github.com/protocolbuffers/protobuf.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :versioned_formula

  depends_on "python@3.10" => [:build, :test]

  on_linux do
    depends_on "zlib"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-zlib"
    system "make"
    system "make", "check"
    system "make", "install"

    # Install editor support and examples
    pkgshare.install "editors/proto.vim", "examples"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"

    resource("six").stage do
      system Formula["python@3.10"].opt_bin/"python3.10", *Language::Python.setup_install_args(libexec)
    end
    chdir "python" do
      system Formula["python@3.10"].opt_bin/"python3.10", *Language::Python.setup_install_args(libexec),
                        "--cpp_implementation"
    end

    version = Language::Python.major_minor_version Formula["python@3.10"].opt_bin/"python3.10"
    site_packages = "lib/python#{version}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-protobuf.pth").write pth_contents
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."
    # system Formula["python@3.10"].opt_bin/"python3.10", "-c", "import google.protobuf"
  end
end
