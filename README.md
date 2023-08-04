# FiftyOneImageAnnotations

[![Build Status](https://github.com/IHPSystems/FiftyOneImageAnnotations.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/IHPSystems/FiftyOneImageAnnotations.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/IHPSystems/FiftyOneImageAnnotations.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/IHPSystems/FiftyOneImageAnnotations.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

FiftyOneImageAnnotations provides a Julia interface to the [FiftyOne](https://voxel51.com/docs/fiftyone/) toolkit, that enables curating datasets, evaluating models, finding annotation mistakes, visualizing embeddings etc.

## Limitations

There is currently very little usable functionality, as focus so far has been on wrapping the [Dataset](https://github.com/voxel51/fiftyone/blob/develop/fiftyone/core/dataset.py) class.

## Caveats

The embedded MongoDB process is left running after the Julia session is closed. Stop the process manually - or, preferable, [use an external MongoDB instance](https://docs.voxel51.com/user_guide/config.html#configuring-a-mongodb-connection).

The MongoDB process [can be terminated](https://www.mongodb.com/docs/manual/tutorial/manage-mongodb-processes/#use-kill) using:
```
kill -3 `ps | grep fiftyone | grep -v service/main.py | grep mongod | cut -d " " -f 1`
```
This is somewhat **unsafe**: The MongoDB documentation says that signal 2/INT should be used, but it seems 3/QUIT actually works.

## Usage

```julia
using FiftyOneImageAnnotations

foo_dataset = Dataset("foo")
Dataset("bar"; persistent = true)

list_datasets() # lists "foo" and "bar" datasets

bar_dataset = load_dataset("bar")

foo_dataset.persistent # false
bar_dataset.persistent # true

delete_non_persistent_datasets()

delete_dataset("bar")
```

## Development

Installing FiftyOne can take a long time - [disabling installation of dependencies with CondaPkg](https://cjdoris.github.io/PythonCall.jl/stable/pythoncall/#pythoncall-config) can speed up development significanly (once the dependencies are installed):
```sh
JULIA_CONDAPKG_BACKEND=Null JULIA_PYTHONCALL_EXE=`pwd`/.CondaPkg/env/bin/python julia --project
```
