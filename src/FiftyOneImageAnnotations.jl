module FiftyOneImageAnnotations

using GeometryBasics
using ImageAnnotations
using PythonCall

export Classification, Detection, FiftyOneLabel, Polyline, Regression

export Sample

export ImageAnnotationDatasetExporter, ImageAnnotationDatasetImporter, ImageAnnotationDatasetType

include(joinpath(@__DIR__, "core", "collections_exports.jl"))
include(joinpath(@__DIR__, "core", "dataset_exports.jl"))

include(joinpath(@__DIR__, "PythonExtension", "PythonExtension.jl"))

const fiftyone = PythonExtension.fiftyone

include(joinpath(@__DIR__, "types.jl"))

include(joinpath(@__DIR__, "core", "expressions.jl"))
include(joinpath(@__DIR__, "core", "collections.jl"))
include(joinpath(@__DIR__, "core", "fields.jl"))
include(joinpath(@__DIR__, "core", "frame.jl"))
include(joinpath(@__DIR__, "core", "groups.jl"))
include(joinpath(@__DIR__, "core", "labels.jl"))
include(joinpath(@__DIR__, "core", "sample.jl"))
include(joinpath(@__DIR__, "core", "view.jl"))
include(joinpath(@__DIR__, "core", "dataset.jl"))

include(joinpath(@__DIR__, "util", "data", "importers.jl"))

end
