# FiftyOneImageAnnotations

[![Build Status](https://github.com/IHPSystems/FiftyOneImageAnnotations.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/IHPSystems/FiftyOneImageAnnotations.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/IHPSystems/FiftyOneImageAnnotations.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/IHPSystems/FiftyOneImageAnnotations.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

## Development

Installing FiftyOne can take a long time - [disabling installation of dependencies with CondaPkg](https://cjdoris.github.io/PythonCall.jl/stable/pythoncall/#pythoncall-config) can speed up development significanly (once the dependencies are installed):
```sh
JULIA_CONDAPKG_BACKEND=Null JULIA_PYTHONCALL_EXE=`pwd`/.CondaPkg/env/bin/python julia --project
```
