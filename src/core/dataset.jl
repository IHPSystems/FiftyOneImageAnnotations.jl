struct Dataset <: AbstractSampleCollection
    object::Py
end

PythonCall.ispy(dataset::Dataset) = true

PythonCall.Py(dataset::Dataset) = dataset.object

Dataset(; kwargs...) = Dataset(fiftyone.Dataset(; kwargs...))

Dataset(name::AbstractString; kwargs...) = Dataset(fiftyone.Dataset(; name, kwargs...))

Base.:(==)(a::Dataset, b::Dataset) = pyeq(Bool, a, b)

# Properties

function Base.propertynames(dataset::Dataset, private::Bool = false)
    names = propertynames(dataset.object)
    filter!(n -> !startswith(String(n), "_"), names)
    filter!(n -> !pycallable(getproperty(dataset.object, n)), names)
    if private
        append!(names, fieldnames(Dataset))
    end
    return names
end

function Base.getproperty(dataset::Dataset, name::Symbol)
    if name in fieldnames(Dataset)
        return getfield(dataset, name)
    end
    if name == :schema
        return dataset.object.default_classes
    elseif name == :annotated_images
        return dataset
    end
    return pyconvert(Any, getproperty(dataset.object, name))
end

Base.setproperty!(dataset::Dataset, name::Symbol, value) = setproperty!(dataset.object, name, value)

# Iteration interface, cf. https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-iteration

Base.eltype(::Type{Dataset}) = Sample

Base.length(dataset::Dataset) = length(dataset.object)

function Base.iterate(dataset::Dataset)
    next = iterate(dataset.object)
    return next === nothing ? nothing : (Sample(first(next)), last(next))
end

function Base.iterate(dataset::Dataset, state)
    next = iterate(dataset.object, state)
    return next === nothing ? nothing : (Sample(first(next)), last(next))
end

# Indexing interface, cf. https://docs.julialang.org/en/v1/manual/interfaces/#Indexing

Base.getindex(dataset::Dataset, s::AbstractString) = Sample(getindex(dataset.object, s))

# Methods

summary(dataset::Dataset) = dataset.object.summary()

view(dataset::Dataset) = DatasetView(dataset.object.view())

get_field_schema(dataset::Dataset; kwargs...) = dataset.object.get_field_schema(; kwargs...)

get_frame_field_schema(dataset::Dataset; kwargs...) = dataset.object.get_frame_field_schema(; kwargs...)

function add_sample_field!(dataset::Dataset, field_name::AbstractString, ftype::Type{<:AbstractField}; kwargs...)
    return dataset.object.add_sample_field(field_name, ftype; kwargs...)
end

add_dynamic_sample_fields!(dataset::Dataset; kwargs...) = dataset.object.add_dynamic_sample_fields(; kwargs...)

function add_frame_field!(dataset::Dataset, field_name::AbstractString, ftype::Type{<:AbstractField}; kwargs...)
    return dataset.object.add_frame_field(field_name, ftype; kwargs...)
end

add_dynamic_frame_fields!(dataset::Dataset; kwargs...) = dataset.object.add_dynamic_frame_fields(; kwargs...)

add_group_field!(dataset::Dataset, field_name::AbstractString; kwargs...) = dataset.object.add_group_field(field_name; kwargs...)

function rename_sample_field!(dataset::Dataset, field_name::AbstractString, new_field_name::AbstractString)
    return dataset.object.rename_sample_field(field_name, new_field_name)
end

function rename_sample_fields!(dataset::Dataset, field_mapping::Dict{AbstractString, AbstractString})
    return dataset.object.rename_sample_fields(field_mapping)
end

function rename_frame_field!(dataset::Dataset, field_name::AbstractString, new_field_name::AbstractString)
    return dataset.object.rename_frame_field(field_name, new_field_name)
end

function rename_frame_fields!(dataset::Dataset, field_mapping::Dict{AbstractString, AbstractString})
    return dataset.object.rename_frame_fields(field_mapping)
end

function clone_sample_field!(dataset::Dataset, field_name::AbstractString, new_field_name::AbstractString)
    return dataset.object.clone_sample_field(field_name, new_field_name)
end

function clone_sample_fields!(dataset::Dataset, field_mapping::Dict{AbstractString, AbstractString})
    return dataset.object.clone_sample_fields(field_mapping)
end

function clone_frame_field!(dataset::Dataset, field_name::AbstractString, new_field_name::AbstractString)
    return dataset.object.clone_frame_field(field_name, new_field_name)
end

function clone_frame_fields!(dataset::Dataset, field_mapping::Dict{AbstractString, AbstractString})
    return dataset.object.clone_frame_fields(field_mapping)
end

clear_sample_field!(dataset::Dataset, field_name::AbstractString) = dataset.object.clear_sample_field(field_name)

clear_sample_fields!(dataset::Dataset, field_names::Vector{AbstractString}) = dataset.object.clear_sample_fields(field_names)

clear_frame_field!(dataset::Dataset, field_name::AbstractString) = dataset.object.clear_frame_field(field_name)

clear_frame_fields!(dataset::Dataset, field_names::Vector{AbstractString}) = dataset.object.clear_frame_fields(field_names)

delete_sample_field!(dataset::Dataset, field_name::AbstractString; kwargs...) = dataset.object.delete_sample_field(field_name; kwargs...)

function delete_sample_fields!(dataset::Dataset, field_names::Vector{AbstractString}; kwargs...)
    return dataset.object.delete_sample_fields(field_names; kwargs...)
end

function remove_dynamic_sample_field!(dataset::Dataset, field_name::AbstractString; kwargs...)
    return dataset.object.remove_dynamic_sample_field(field_name; kwargs...)
end

function remove_dynamic_sample_fields!(dataset::Dataset, field_names::Vector{AbstractString}; kwargs...)
    return dataset.object.remove_dynamic_sample_fields(field_names; kwargs...)
end

delete_frame_field!(dataset::Dataset, field_name::AbstractString; kwargs...) = dataset.object.delete_frame_field(field_name; kwargs...)

function delete_frame_fields!(dataset::Dataset, field_names::Vector{AbstractString}; kwargs...)
    return dataset.object.delete_frame_fields(field_names; kwargs...)
end

function remove_dynamic_frame_field!(dataset::Dataset, field_name::AbstractString; kwargs...)
    return dataset.object.remove_dynamic_frame_field(field_name; kwargs...)
end

function remove_dynamic_frame_fields!(dataset::Dataset, field_names::Vector{AbstractString}; kwargs...)
    return dataset.object.remove_dynamic_frame_fields(field_names; kwargs...)
end

add_group_slice!(dataset::Dataset, name::AbstractString, media_type::Any) = dataset.object.add_group_slice(name, media_type)

rename_group_slice!(dataset::Dataset, name::AbstractString, new_name::AbstractString) = dataset.object.rename_group_slice(name, new_name)

delete_group_slice!(dataset::Dataset, name::AbstractString) = dataset.object.delete_group_slice(name)

iter_samples(dataset::Dataset; kwargs...) = dataset.object.iter_samples(; kwargs...)

iter_groups(dataset::Dataset; kwargs...) = dataset.object.iter_groups(; kwargs...)

get_group(dataset::Dataset, group_id::AbstractString; kwargs...) = dataset.object.get_group(group_id; kwargs...)

add_sample!(dataset::Dataset, sample::Sample; kwargs...) = dataset.object.add_sample(sample; kwargs...)

add_samples!(dataset::Dataset, samples::Vector{Sample}; kwargs...) = dataset.object.add_samples(samples; kwargs...)

function add_collection!(dataset::Dataset, sample_collection::AbstractSampleCollection; kwargs...)
    return dataset.object.add_collection(sample_collection; kwargs...)
end

merge_samples!(dataset::Dataset, samples::Vector{Sample}; kwargs...) = dataset.object.merge_samples(samples; kwargs...)

function delete_samples!(dataset::Dataset, samples_or_ids::Union{Vector{Sample}, Vector{AbstractString}})
    return dataset.object.delete_samples(samples_or_ids)
end

delete_frames!(dataset::Dataset, frames_or_ids::Union{Vector{Frame}, Vector{AbstractString}}) = dataset.object.delete_frames(frames_or_ids)

delete_groups!(dataset::Dataset, groups_or_ids::Union{Vector{Group}, Vector{AbstractString}}) = dataset.object.delete_groups(groups_or_ids)

delete_labels!(dataset::Dataset; kwargs...) = dataset.object.delete_labels(; kwargs...)

save!(dataset::Dataset) = dataset.object.save()

has_saved_view(dataset::Dataset, name::AbstractString) = dataset.object.has_saved_view(name)

list_saved_views(dataset::Dataset) = dataset.object.list_saved_views()

save_view!(dataset::Dataset, name::AbstractString, view::DatasetView; kwargs...) = dataset.object.save_view(name, view; kwargs...)

get_saved_view_info(dataset::Dataset, name::AbstractString) = dataset.object.get_saved_view_info(name)

function update_saved_view_info!(dataset::Dataset, name::AbstractString, info::Dict{AbstractString, Any})
    return dataset.object.update_saved_view_info(name, info)
end

load_saved_view(dataset::Dataset, name::AbstractString) = dataset.object.load_saved_view(name)

delete_saved_view!(dataset::Dataset, name::AbstractString) = dataset.object.delete_saved_view(name)

delete_saved_views!(dataset::Dataset) = dataset.object.delete_saved_views()

clone(dataset::Dataset; kwargs...) = dataset.object.clone(; kwargs...)

clear!(dataset::Dataset) = dataset.object.clear()

clear_frames!(dataset::Dataset) = dataset.object.clear_frames()

ensure_frames!(dataset::Dataset) = dataset.object.ensure_frames()

Base.delete!(dataset::Dataset) = dataset.object.delete()

add_dir!(dataset::Dataset; kwargs...) = dataset.object.add_dir(; kwargs...)

merge_dir!(dataset::Dataset; kwargs...) = dataset.object.merge_dir(; kwargs...)

add_archive!(dataset::Dataset, archive_path::AbstractString; kwargs...) = dataset.object.add_archive(archive_path; kwargs...)

merge_archive!(dataset::Dataset, archive_path::AbstractString; kwargs...) = dataset.object.merge_archive(archive_path; kwargs...)

function add_importer!(dataset::Dataset, dataset_importer::AbstractDatasetImporter; kwargs...)
    return dataset.object.add_importer(dataset_importer; kwargs...)
end

function merge_importer!(dataset::Dataset, dataset_importer::AbstractDatasetImporter; kwargs...)
    return dataset.object.merge_importer(dataset_importer; kwargs...)
end

function add_images!(dataset::Dataset, paths_or_samples::Union{Vector{AbstractString}, Vector{Sample}}; kwargs...)
    return dataset.object.add_images(paths_or_samples; kwargs...)
end

function add_labeled_images!(dataset::Dataset, samples::AbstractVector{Sample}, sample_parser::AbstractSampleParser; kwargs...)
    return dataset.object.add_labeled_images(samples, sample_parser; kwargs...)
end

add_images_dir!(dataset::Dataset, dirpath::AbstractString; kwargs...) = dataset.object.add_images_dir(dirpath; kwargs...)

add_images_pattern!(dataset::Dataset, images_patt::AbstractString; kwargs...) = dataset.object.add_images_pattern(images_patt; kwargs...)

function ingest_images!(dataset::Dataset, paths_or_samples::Union{Vector{AbstractString}, Vector{Sample}}; kwargs...)
    return dataset.object.ingest_images(paths_or_samples; kwargs...)
end

function ingest_labeled_images!(dataset::Dataset, samples::AbstractVector{Sample}, sample_parser::AbstractSampleParser; kwargs...)
    return dataset.object.ingest_labeled_images(samples, sample_parser; kwargs...)
end

function add_videos!(dataset::Dataset, paths_or_samples::Union{Vector{AbstractString}, Vector{Sample}}; kwargs...)
    return dataset.object.add_videos(paths_or_samples; kwargs...)
end

function add_labeled_videos!(dataset::Dataset, samples::AbstractVector{Sample}, sample_parser::AbstractSampleParser; kwargs...)
    return dataset.object.add_labeled_videos(samples, sample_parser; kwargs...)
end

add_videos_dir!(dataset::Dataset, videos_dir::AbstractString; kwargs...) = dataset.object.add_videos_dir(videos_dir; kwargs...)

add_videos_pattern!(dataset::Dataset, videos_patt::AbstractString; kwargs...) = dataset.object.add_videos_pattern(videos_patt; kwargs...)

function ingest_videos!(dataset::Dataset, paths_or_samples::Union{Vector{AbstractString}, Vector{Sample}}; kwargs...)
    return dataset.object.ingest_videos(paths_or_samples; kwargs...)
end

function ingest_labeled_videos!(dataset::Dataset, samples::AbstractVector{Sample}, sample_parser::AbstractSampleParser; kwargs...)
    return dataset.object.ingest_labeled_videos(samples, sample_parser; kwargs...)
end

function export_samples(
    dataset::Dataset,
    ::Type{ImageAnnotationDatasetExporter};
    data_path::Union{String, Nothing} = nothing,
    angular_atol::Real = 0,
    digits::Int = 10,
)
    annotated_images = AnnotatedImage[]
    for annotated_image in dataset.annotated_images
        image_file_path = annotated_image.image_file_path
        image_width = annotated_image.image_width
        image_height = annotated_image.image_height
        new_annotations = AbstractImageAnnotation[]
        if !isnothing(data_path)
            image_file_path = chopprefix(annotated_image.image_file_path, normpath(data_path))
        end
        image_file_path = replace(image_file_path, "\\" => "/")
        for annotation in annotated_image.annotations
            label = get_label(annotation)
            new_label = Label(label.value, label.attributes)
            confidence = get_confidence(annotation)
            if annotation isa AbstractBoundingBoxAnnotation
                rect = get_bounding_box(annotation)
                origin = rect.origin .* (image_width, image_height)
                widths = rect.widths .* (image_width, image_height)
                top_left = Point2{Float64}(origin)
                push!(new_annotations, BoundingBoxAnnotation(top_left, widths..., new_label))
            elseif annotation isa AbstractPolygonAnnotation
                vertices = Point2{Float64}[]
                for v in get_vertices(annotation)
                    v = v .* (image_width, image_height)
                    push!(vertices, v)
                end
                polygon_annotation = PolygonAnnotation(vertices, new_label)
                polygon_annotation = simplify_geometry(polygon_annotation; angular_atol, digits)
                push!(new_annotations, polygon_annotation)
            elseif annotation isa AbstractImageAnnotation
                push!(new_annotations, ImageAnnotation(new_label; confidence))
            else
                error("Unknown annotation type: $(typeof(annotation))")
            end
        end
        push!(annotated_images, AnnotatedImage(new_annotations; image_file_path, image_width, image_height))
    end
    return ImageAnnotationDataSet(annotated_images)
end

# Class methods

dataset_from_dir(dataset_dir::AbstractString; kwargs...) = Dataset(fiftyone.Dataset.from_dir(dataset_dir; kwargs...))

dataset_from_archive(archive_path::AbstractString; kwargs...) = Dataset(fiftyone.Dataset.from_archive(archive_path; kwargs...))

function dataset_from_importer(dataset_importer::AbstractDatasetImporter; kwargs...)
    return Dataset(fiftyone.Dataset.from_importer(dataset_importer; kwargs...))
end

function dataset_from_images(paths_or_samples::Union{Vector{AbstractString}, Vector{Sample}}; kwargs...)
    return Dataset(fiftyone.Dataset.from_images(paths_or_samples; kwargs...))
end

function dataset_from_labeled_images(samples::AbstractVector{Sample}, sample_parser::AbstractSampleParser; kwargs...)
    return Dataset(fiftyone.Dataset.from_labeled_images(samples, sample_parser; kwargs...))
end

dataset_from_images_dir(images_dir::AbstractString; kwargs...) = Dataset(fiftyone.Dataset.from_images_dir(images_dir; kwargs...))

dataset_from_images_pattern(images_patt::AbstractString; kwargs...) = Dataset(fiftyone.Dataset.from_images_patt(images_patt; kwargs...))

function dataset_from_videos(paths_or_samples::Union{Vector{AbstractString}, Vector{Sample}}; kwargs...)
    return Dataset(fiftyone.Dataset.from_videos(paths_or_samples; kwargs...))
end

function dataset_from_labeled_videos(samples::AbstractVector{Sample}, sample_parser::AbstractSampleParser; kwargs...)
    return Dataset(fiftyone.Dataset.from_labeled_videos(samples, sample_parser; kwargs...))
end

dataset_from_videos_dir(videos_dir::AbstractString; kwargs...) = Dataset(fiftyone.Dataset.from_videos_dir(videos_dir; kwargs...))

dataset_from_videos_pattern(videos_patt::AbstractString; kwargs...) = Dataset(fiftyone.Dataset.from_videos_patt(videos_patt; kwargs...))

dataset_from_dict(d::Dict{<:AbstractString, <:Any}; kwargs...) = Dataset(fiftyone.Dataset.from_dict(d; kwargs...))

dataset_from_json(path_or_str::AbstractString; kwargs...) = Dataset(fiftyone.Dataset.from_json(path_or_str; kwargs...))

# Functions

reload!(dataset::Dataset) = dataset.object.reload()

clear_cache!(dataset::Dataset) = dataset.object.clear_cache()

list_datasets(; kwargs...) = PyList{String}(fiftyone.list_datasets(; kwargs...))

dataset_exists(name::AbstractString) = Bool(fiftyone.dataset_exists(name))

load_dataset(name::AbstractString) = Dataset(fiftyone.load_dataset(name))

delete_dataset(name::AbstractString; verbose::Bool = false) = fiftyone.delete_dataset(name, verbose)

delete_datasets(glob_patt::AbstractString; verbose::Bool = false) = fiftyone.delete_datasets(glob_patt, verbose)

delete_non_persistent_datasets(; verbose::Bool = false) = fiftyone.delete_non_persistent_datasets(verbose)
