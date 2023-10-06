struct ImageAnnotationDatasetImporter <: AbstractDatasetImporter
    object::Py
end

function ImageAnnotationDatasetImporter(
    dataset::AbstractImageAnnotationDataSet;
    shuffle::Bool = false,
    seed::Union{Int, Nothing} = nothing,
    max_samples::Union{Int, Nothing} = nothing,
    data_path::Union{AbstractString, Nothing} = nothing,
    bounding_box_annotation_type::Union{Type{Detection}, Type{Polyline}} = Detection,
)
    bounding_box_annotation_py_type =
        bounding_box_annotation_type === Detection ? fiftyone.core.labels.Detection : fiftyone.core.labels.Polyline
    object = PythonExtension.ImageAnnotationDatasetImporter(
        dataset; shuffle, seed, max_samples, data_path, bounding_box_annotation_type = bounding_box_annotation_py_type
    )
    return ImageAnnotationDatasetImporter(object)
end

PythonCall.ispy(importer::ImageAnnotationDatasetImporter) = true

PythonCall.Py(importer::ImageAnnotationDatasetImporter) = importer.object
