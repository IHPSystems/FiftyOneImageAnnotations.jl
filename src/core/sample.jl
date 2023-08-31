struct Sample <: AbstractAnnotatedImage
    object::Py
end

PythonCall.ispy(sample::Sample) = true

PythonCall.Py(sample::Sample) = sample.object

# Properties

function Base.propertynames(sample::Sample, private::Bool = false)
    names = propertynames(sample.object)
    filter!(n -> !startswith(String(n), "_"), names)
    filter!(n -> !pycallable(getproperty(sample.object, n)), names)
    if private
        append!(names, fieldnames(Sample))
    end
    append!(names, [:annotations, :image_file_path, :image_height, :image_width])
    return names
end

function Base.getproperty(sample::Sample, name::Symbol)
    if name in fieldnames(Sample)
        return getfield(sample, name)
    end
    if name == :annotations
        annotations = AbstractImageAnnotation{FiftyOneLabel}[]
        for field_name in sample.object.field_names
            labels_field = sample.object[field_name]
            if pyis(pytype(labels_field), fiftyone.core.labels.Classification)
                labels_field = fiftyone.core.labels.Classifications(; classifications = pylist(labels_field))
            elseif pyis(pytype(labels_field), fiftyone.core.labels.Detection)
                labels_field = fiftyone.core.labels.Detections(; detections = pylist(labels_field))
            elseif pyis(pytype(labels_field), fiftyone.core.labels.Polyline)
                labels_field = fiftyone.core.labels.Polylines(; polylines = pylist(labels_field))
            end
            if pyis(pytype(labels_field), fiftyone.core.labels.Classifications)
                labels = labels_field["classifications"]
                for label in labels
                    annotation = Classification(label)
                    annotation.attributes = pydict(Dict())
                    push!(annotations, annotation)
                end
            elseif pyis(pytype(labels_field), fiftyone.core.labels.Detections)
                labels = labels_field["detections"]
                for label in labels
                    annotation = Detection(label)
                    for (i, attribute) in label.iter_attributes()
                        annotation.attributes[i] = attribute
                    end
                    push!(annotations, annotation)
                end
            elseif pyis(pytype(labels_field), fiftyone.core.labels.Polylines)
                labels = labels_field["polylines"]
                for label in labels
                    annotation = Polyline(label)
                    for (i, attribute) in label.iter_attributes()
                        annotation.attributes[i] = attribute
                    end
                    push!(annotations, annotation)
                end
            elseif pyis(pytype(labels_field), fiftyone.core.labels.Regression)
                annotation = Regression(labels_field)
                annotation.attributes = pydict(Dict())
                push!(annotations, annotation)
            end
        end
        return annotations
    elseif name == :image_file_path
        return pyconvert(String, sample.object.filepath)
    elseif name == :image_height
        return pyis(sample.object.metadata, pybuiltins.None) ? nothing : pyconvert(Int, sample.object.metadata.height)
    elseif name == :image_width
        return pyis(sample.object.metadata, pybuiltins.None) ? nothing : pyconvert(Int, sample.object.metadata.width)
    end
    return pyconvert(Any, getproperty(sample.object, name))
end

function Base.isless(a::Sample, b::Sample)
    if a.image_file_path !== nothing && b.image_file_path !== nothing
        return a.image_file_path < b.image_file_path
    end
    return a.annotations < b.annotations
end
