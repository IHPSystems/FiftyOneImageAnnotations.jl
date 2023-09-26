module FiftyOneImageAnnotations

using ImageAnnotations
using PythonCall

export ImageAnnotationDatasetImporter, ImageAnnotationDatasetType

include(joinpath(@__DIR__, "PythonExtension", "PythonExtension.jl"))

const fiftyone = PythonExtension.fiftyone

include(joinpath(@__DIR__, "util", "data", "importers.jl"))
include(joinpath(@__DIR__, "util", "data", "parsers.jl"))

include(joinpath(@__DIR__, "core", "collections.jl"))
include(joinpath(@__DIR__, "core", "fields.jl"))
include(joinpath(@__DIR__, "core", "frame.jl"))
include(joinpath(@__DIR__, "core", "groups.jl"))
include(joinpath(@__DIR__, "core", "sample.jl"))
include(joinpath(@__DIR__, "core", "view.jl"))
include(joinpath(@__DIR__, "core", "dataset.jl"))
include(joinpath(@__DIR__, "core", "dataset_exports.jl"))

end
