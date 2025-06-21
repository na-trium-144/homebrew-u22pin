# u22pin

Ubuntu22.04と同じバージョンのパッケージをMacに入れようというプロジェクト

```sh
brew tap na-trium-144/u22pin
brew install boost@1.74 cmake@3.22 eigen@3.4 fmt@8 google-benchmark@1.6 googletest@1.11 grpc@1.30 nlohmann-json@3.10 protobuf@3.12 spdlog@1.9
```

bashrcやzshrcあたりに
```bash
function u22pin(){
# ==> boost@1.74
  export BOOST_ROOT="$(brew --prefix boost@1.74)"
  export CMAKE_PREFIX_PATH="$(brew --prefix boost@1.74):$CMAKE_PREFIX_PATH"
# ==> cmake@3.22
  export PATH="$(brew --prefix cmake@3.22)/bin:$PATH"
# ==> eigen@3.4
  export PKG_CONFIG_PATH="$(brew --prefix eigen@3.4)/share/pkgconfig:$PKG_CONFIG_PATH"
  export CMAKE_PREFIX_PATH="$(brew --prefix eigen@3.4):$CMAKE_PREFIX_PATH"
# ==> fmt@8
  export PKG_CONFIG_PATH="$(brew --prefix fmt@8)/lib/pkgconfig:$PKG_CONFIG_PATH"
  export CMAKE_PREFIX_PATH="$(brew --prefix fmt@8):$CMAKE_PREFIX_PATH"
# ==> google-benchmark@1.6
  export PKG_CONFIG_PATH="$(brew --prefix google-benchmark@1.6)/lib/pkgconfig:$PKG_CONFIG_PATH"
  export CMAKE_PREFIX_PATH="$(brew --prefix google-benchmark@1.6):$CMAKE_PREFIX_PATH"
# ==> googletest@1.11
  export GTEST_ROOT="$(brew --prefix googletest@1.11)"
  export PKG_CONFIG_PATH="$(brew --prefix googletest@1.11)/lib/pkgconfig:$PKG_CONFIG_PATH"
  export CMAKE_PREFIX_PATH="$(brew --prefix googletest@1.11):$CMAKE_PREFIX_PATH"
# ==> grpc@1.30
  export PATH="$(brew --prefix grpc@1.30)/bin:$PATH"
  export PKG_CONFIG_PATH="$(brew --prefix grpc@1.30)/lib/pkgconfig:$PKG_CONFIG_PATH"
# ==> nlohmann-json@3.10
  export PKG_CONFIG_PATH="$(brew --prefix nlohmann-json@3.10)/lib/pkgconfig:$PKG_CONFIG_PATH"
  export CMAKE_PREFIX_PATH="$(brew --prefix nlohmann-json@3.10):$CMAKE_PREFIX_PATH"
# ==> protobuf@3.12
  export PATH="$(brew --prefix protobuf@3.12)/bin:$PATH"
  export PKG_CONFIG_PATH="$(brew --prefix protobuf@3.12)/lib/pkgconfig:$PKG_CONFIG_PATH"
# ==> spdlog@1.9
  export PKG_CONFIG_PATH="$(brew --prefix spdlog@1.9)/lib/pkgconfig:$PKG_CONFIG_PATH"
  export CMAKE_PREFIX_PATH="$(brew --prefix spdlog@1.9):$CMAKE_PREFIX_PATH"
}
```
などと書いて、`u22pin`でアクティベートできるようにするとよさそう

<details><summary>LDFLAGS / CPPFLAGS で指定したい場合</summary>

```bash
function u22pin(){
# ==> boost@1.74
  export LDFLAGS="-L$(brew --prefix boost@1.74)/lib:$LDFLAGS"
  export CPPFLAGS="-I$(brew --prefix boost@1.74)/include:$CPPFLAGS"
# ==> cmake@3.22
  export PATH="$(brew --prefix cmake@3.22)/bin:$PATH"
# ==> eigen@3.4
  export CPPFLAGS="-I$(brew --prefix eigen@3.4)/include:$CPPFLAGS"
# ==> fmt@8
  export LDFLAGS="-L$(brew --prefix fmt@8)/lib:$LDFLAGS"
  export CPPFLAGS="-I$(brew --prefix fmt@8)/include:$CPPFLAGS"
# ==> google-benchmark@1.6
  export LDFLAGS="-L$(brew --prefix google-benchmark@1.6)/lib:$LDFLAGS"
  export CPPFLAGS="-I$(brew --prefix google-benchmark@1.6)/include:$CPPFLAGS"
# ==> googletest@1.11
  export LDFLAGS="-L$(brew --prefix googletest@1.11)/lib:$LDFLAGS"
  export CPPFLAGS="-I$(brew --prefix googletest@1.11)/include:$CPPFLAGS"
# ==> grpc@1.30
  export PATH="$(brew --prefix grpc@1.30)/bin:$PATH"
  export LDFLAGS="-L$(brew --prefix grpc@1.30)/lib:$LDFLAGS"
  export CPPFLAGS="-I$(brew --prefix grpc@1.30)/include:$CPPFLAGS"
# ==> nlohmann-json@3.10
  export LDFLAGS="-L$(brew --prefix nlohmann-json@3.10)/lib:$LDFLAGS"
  export CPPFLAGS="-I$(brew --prefix nlohmann-json@3.10)/include:$CPPFLAGS"
# ==> protobuf@3.12
  export LDFLAGS="-L$(brew --prefix protobuf@3.12)/lib:$LDFLAGS"
  export CPPFLAGS="-I$(brew --prefix protobuf@3.12)/include:$CPPFLAGS"
# ==> spdlog@1.9
  export LDFLAGS="-L$(brew --prefix spdlog@1.9)/lib:$LDFLAGS"
  export CPPFLAGS="-I$(brew --prefix spdlog@1.9)/include:$CPPFLAGS"
}
```

</details>

