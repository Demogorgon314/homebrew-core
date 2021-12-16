class ClangFormatAT5 < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://releases.llvm.org/5.0.2/llvm-5.0.2.src.tar.xz"
  sha256 "d522eda97835a9c75f0b88ddc81437e5edbb87dc2740686cb8647763855c2b3c"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "487c96e15eb0d1460df9453b4ebf3dc2332601f39fd476df9d182cb006b7c16d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f7277da699e1b3c7f20c256c25093b5833e164b52134d2697979b6c29fb7757"
    sha256 cellar: :any_skip_relocation, monterey:       "d529cbffdef8a529c7c7f23b3be5aba8e0da29fc5b8aa2ffacddc29fa99b18d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c019f2355036a45a2e084fe1c5a7253225c2abb1c0c330f46e41d05f619106fe"
    sha256 cellar: :any_skip_relocation, catalina:       "30b5274aa2f2fc590ac2bd4e7152c40c5fd76ec779703cd3898b5e2d46d563f8"
    sha256 cellar: :any_skip_relocation, mojave:         "d1fa0fa103bb53196f1289b2587e35e615bf3d4bf0b1c71f32a5f66effd3726a"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "clang" do
    url "https://releases.llvm.org/5.0.2/cfe-5.0.2.src.tar.xz"
    sha256 "fa9ce9724abdb68f166deea0af1f71ca0dfa9af8f7e1261f2cae63c280282800"
  end

  def install
    (buildpath/"tools/clang").install resource("clang")

    mkdir buildpath/"build" do
      args = std_cmake_args
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
    end

    bin.install buildpath/"build/bin/clang-format" => "clang-format-5"
    bin.install buildpath/"tools/clang/tools/clang-format/git-clang-format" => "git-clang-format-5"
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format-5 -style=Google test.c")
  end
end
