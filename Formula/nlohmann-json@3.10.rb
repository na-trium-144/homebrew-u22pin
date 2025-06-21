class NlohmannJsonAT310 < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/refs/tags/v3.10.5.tar.gz"
  sha256 "5daca6ca216495edf89d167f808d1d03c4a4d929cef7da5e10f135ae1540c7e4"
  license "MIT"
  head "https://github.com/nlohmann/json.git", branch: "develop"

  bottle do
    root_url "https://github.com/na-trium-144/homebrew-u22pin/releases/download/nlohmann-json@3.10-3.10.5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba715c034067f0bd222d8ea9b08d070b2aadd4cdb1e8b8a0dfe1d40bbbb187bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "232afcfbe1e72fa87d0d561ac81c7baa5a58ce88ea47eef127b22208a860e68e"
    sha256 cellar: :any_skip_relocation, ventura:       "87f7c578a063d506887b6e786b12e96549d77e67d27b8f732364dedf9bcbf8ce"
  end

  keg_only :versioned_formula

  depends_on "cmake@3.22" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DJSON_BuildTests=OFF", "-DJSON_MultipleHeaders=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <nlohmann/json.hpp>

      using nlohmann::json;

      int main() {
        json j = {
          {"pi", 3.141},
          {"name", "Niels"},
          {"list", {1, 0, 2}},
          {"object", {
            {"happy", true},
            {"nothing", nullptr}
          }}
        };
        std::cout << j << std::endl;
      }
    EOS

    system ENV.cxx, "test.cc", "-I#{include}", "-std=c++11", "-o", "test"
    std_output = <<~EOS
      {"list":[1,0,2],"name":"Niels","object":{"happy":true,"nothing":null},"pi":3.141}
    EOS
    assert_match std_output, shell_output("./test")
  end
end
