abstract type AbstractDatasetImporter end

struct ImageAnnotationDatasetImporter <: AbstractDatasetImporter
    object::Py
end

function ImageAnnotationDatasetImporter(
    dataset::AbstractImageAnnotationDataSet;
    shuffle::Bool = false,
    seed::Union{Int, Nothing} = nothing,
    max_samples::Union{Int, Nothing} = nothing,
    data_path::Union{AbstractString, Nothing} = nothing,
)
    object = PythonExtension.ImageAnnotationDatasetImporter(dataset; shuffle, seed, max_samples, data_path)
    return ImageAnnotationDatasetImporter(object)
end

PythonCall.ispy(importer::ImageAnnotationDatasetImporter) = true

PythonCall.Py(importer::ImageAnnotationDatasetImporter) = importer.object
