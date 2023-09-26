module PythonExtension

using ImageAnnotations
using PythonCall

const fiftyone = PythonCall.pynew()

const ImageAnnotationDatasetImporter = PythonCall.pynew()
const ImageAnnotationDatasetType = PythonCall.pynew()

function __init__()
    PythonCall.pycopy!(fiftyone, pyimport("fiftyone"))
    PythonCall.pycopy!(ImageAnnotationDatasetImporter, define_image_annotation_dataset_importer())
    PythonCall.pycopy!(ImageAnnotationDatasetType, define_image_annotation_dataset_type())
    return nothing
end

include("image_annotations_importer.jl")

end
