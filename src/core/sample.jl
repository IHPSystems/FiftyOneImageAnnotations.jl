struct Sample
    object::Py
end

PythonCall.ispy(sample::Sample) = true

PythonCall.Py(sample::Sample) = sample.object
