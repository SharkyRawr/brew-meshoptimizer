class Meshoptimizer < Formula
  desc "Mesh optimization library that makes meshes smaller and faster to render"
  homepage "https://meshoptimizer.org/"
  url "https://github.com/zeux/meshoptimizer/archive/refs/tags/v1.3.tar.gz"
  sha256 "ca4f47d451201593904b9e3067fa54b65db94bc34ab5173864950862b748a145"
  license "MIT"
  head "https://github.com/zeux/meshoptimizer.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "basis_universal"

  resource "basis_universal" do
    url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/v2_50.tar.gz"
    sha256 "216e49e1f4213d4bfa4afaa07527e16bac28533dddd444197d3aa19230ac130c"
  end

  def install
    inreplace "CMakeLists.txt", "$ORIGIN", "@loader_path" if OS.mac?
    inreplace "CMakeLists.txt", "CXX_STANDARD 11", "CXX_STANDARD 17"

    resource("basis_universal").stage do
      (buildpath/"basis_universal").install Dir["*"]
    end

    args = %W[
      -DMESHOPT_BUILD_GLTFPACK=ON
      -DMESHOPT_BUILD_SHARED_LIBS=ON
      -DMESHOPT_GLTFPACK_BASISU_PATH=#{buildpath}/basis_universal
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <meshoptimizer.h>
      #include <cassert>

      int main() {
        size_t bound = meshopt_encodeIndexBufferBound(3, 3);
        assert(bound > 0);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lmeshoptimizer", "-o", "test"
    system "./test"

    assert_match "gltfpack #{version}", shell_output("#{bin}/gltfpack -v")
  end
end
