# Homebrew Tap for meshoptimizer

Homebrew tap for [meshoptimizer](https://github.com/zeux/meshoptimizer) – a mesh optimization library that makes meshes smaller and faster to render, including the `gltfpack` command-line tool.

## Installation

You can install `meshoptimizer` directly with:

```bash
brew install sharkyrawr/meshoptimizer/meshoptimizer
```

Or tap the repository first:

```bash
brew tap sharkyrawr/meshoptimizer
brew install meshoptimizer
```

## Contents

This formula provides:
- **`gltfpack`**: Command-line tool to optimize glTF files and compress geometry/textures.
- **`libmeshoptimizer`**: Shared library for mesh optimization algorithms.
- **`meshoptimizer.h`**: C/C++ API header file.
- **CMake package config**: Find and link via `find_package(meshoptimizer CONFIG REQUIRED)`.

## Usage

### Command-Line (`gltfpack`)

```bash
gltfpack -i scene.gltf -o scene.glb
```

### CMake Integration

```cmake
find_package(meshoptimizer CONFIG REQUIRED)
target_link_libraries(your_target PRIVATE meshoptimizer::meshoptimizer)
```

### Compiler Flags

```bash
clang++ main.cpp $(pkg-config --cflags --libs meshoptimizer 2>/dev/null || echo "-lmeshoptimizer") -o main
```

## Updating / Development

To test the formula locally:

```bash
brew style Formula/meshoptimizer.rb
brew audit --strict --online Formula/meshoptimizer.rb
brew test Formula/meshoptimizer.rb
```
