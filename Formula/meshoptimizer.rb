class Meshoptimizer < Formula
  desc "Mesh optimization library that makes meshes smaller and faster to render"
  homepage "https://meshoptimizer.org/"
  url "https://github.com/zeux/meshoptimizer/archive/refs/tags/v1.2.tar.gz"
  sha256 "e40f71b809cdf3361b9a4def85fd44534e8733ce29d4b943c145b76859e4c2b4"
  license "MIT"
  head "https://github.com/zeux/meshoptimizer.git", branch: "master"

  depends_on "cmake" => :build

  def install
    inreplace "CMakeLists.txt", "$ORIGIN", "@loader_path" if OS.mac?

    args = %w[
      -DMESHOPT_BUILD_GLTFPACK=ON
      -DMESHOPT_BUILD_SHARED_LIBS=ON
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
