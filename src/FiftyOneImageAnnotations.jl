module FiftyOneImageAnnotations

using ImageAnnotations
using PythonCall

export ImageAnnotationDatasetImporter, ImageAnnotationDatasetType

const fiftyone = PythonCall.pynew()

const ImageAnnotationDatasetImporter = PythonCall.pynew()
const ImageAnnotationDatasetType = PythonCall.pynew()

function __init__()
    PythonCall.pycopy!(fiftyone, pyimport("fiftyone"))
    PythonCall.pycopy!(ImageAnnotationDatasetImporter, define_image_annotation_dataset_importer())
    PythonCall.pycopy!(ImageAnnotationDatasetType, define_image_annotation_dataset_type())
    return nothing
end

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

include("image_annotations_importer.jl")

end
