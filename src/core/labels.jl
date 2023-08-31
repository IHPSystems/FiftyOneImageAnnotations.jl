struct FiftyOneLabel <: AbstractLabel{String}
    object::Py
end

Base.propertynames(::FiftyOneLabel, private::Bool = false) = (:object, :attributes, :label)

function Base.getproperty(label::FiftyOneLabel, name::Symbol)
    if name == :object
        return getfield(label, name)
    elseif name == :attributes
        return pyconvert(Dict, label.object.attributes)
    elseif name == :value
        return pyconvert(String, label.object.label)
    else
        error("Unknown property: $name")
    end
end

struct Regression <: AbstractImageAnnotation{Float64}
    object::Py
end

PythonCall.ispy(regression::Regression) = true

PythonCall.Py(regression::Regression) = regression.object

function Regression(value::Float64; confidence::Union{Float64, Nothing} = nothing)
    return Regression(fiftyone.core.labels.Regression(; value = value, confidence = confidence))
end

struct Classification <: AbstractImageAnnotation{FiftyOneLabel}
    object::Py
end

PythonCall.ispy(classification::Classification) = true

PythonCall.Py(classification::Classification) = classification.object

function Classification(label::String; confidence::Union{Float64, Nothing} = nothing, logits::Union{Vector{Float64}, Nothing} = nothing)
    return Classification(
        fiftyone.core.labels.Classification(;
            label = label, confidence = confidence, logits = logits === nothing ? nothing : pylist(logits)
        ),
    )
end

struct Detection <: AbstractBoundingBoxAnnotation{FiftyOneLabel, Float64}
    object::Py
end

PythonCall.ispy(detection::Detection) = true

PythonCall.Py(detection::Detection) = detection.object

function Detection(label::String, bounding_box::Vector{Float64}; confidence::Union{Float64, Nothing} = nothing)
    return Detection(fiftyone.core.labels.Detection(; label = label, bounding_box = bounding_box, confidence = confidence))
end

ImageAnnotations.get_bounding_box(detection::Detection) = Rect2(get_top_left(detection), get_bottom_right(detection))

ImageAnnotations.get_height(detection::Detection) = detection.bounding_box[4]

ImageAnnotations.get_top_left(detection::Detection) = Point2{Float64}(detection.bounding_box[1:2])

ImageAnnotations.get_width(detection::Detection) = detection.bounding_box[3]

function ImageAnnotations.get_bottom_right(detection::Detection)
    return get_top_left(detection) + Point2(get_width(detection), get_height(detection))
end

struct Polyline <: AbstractPolygonAnnotation{FiftyOneLabel, Float64}
    object::Py
end

PythonCall.ispy(polyline::Polyline) = true

PythonCall.Py(polyline::Polyline) = polyline.object

function Polyline(label::String, vertices::Vector{Point2{Float64}}; confidence::Union{Float64, Nothing} = nothing)
    points = collect(map(v -> (v[1], v[2]), vertices))
    shapes = [points]
    return Polyline(fiftyone.core.labels.Polyline(; label = label, points = shapes, confidence = confidence))
end

ImageAnnotations.get_label(polyline::Polyline) = FiftyOneLabel(polyline.object)

function ImageAnnotations.get_vertices(polyline::Polyline)
    points = polyline.object.points[0]
    return collect(map(p -> Point2(pyconvert(Float64, (p[0])), pyconvert(Float64, (p[1]))), points))
end

# Properties

function Base.propertynames(label::Union{Regression, Classification, Detection, Polyline}, private::Bool = false)
    names = propertynames(label.object)
    filter!(n -> !startswith(String(n), "_"), names)
    filter!(n -> !pycallable(getproperty(label.object, n)), names)
    if private
        append!(names, fieldnames(typeof(label)))
    end
    return names
end

function Base.getproperty(label::Union{Regression, Classification, Detection, Polyline}, name::Symbol)
    if name in fieldnames(typeof(label))
        return getfield(label, name)
    end
    p = pyconvert(Any, getproperty(label.object, name))
    if !(p isa PyList)
        return p
    end
    p = pyconvert.(Any, p)
    return p
end

function Base.setproperty!(label::Union{Regression, Classification, Detection, Polyline}, name::Symbol, value)
    return setproperty!(label.object, name, value)
end

ImageAnnotations.get_label(label::Union{Classification, Detection, Polyline}) = FiftyOneLabel(label.object)

function ImageAnnotations.get_confidence(label::Union{Classification, Detection, Polyline})
    return pyis(label.object.confidence, pybuiltins.None) ? nothing : label.object.confidence
end

ImageAnnotations.get_annotator_name(::Union{Classification, Detection, Polyline}) = nothing
