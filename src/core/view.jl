struct DatasetView <: AbstractSampleCollection
    object::Py
end

PythonCall.ispy(dataset_view::DatasetView) = true

PythonCall.Py(dataset_view::DatasetView) = dataset_view.object
