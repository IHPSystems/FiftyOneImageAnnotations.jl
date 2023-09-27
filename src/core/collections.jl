abstract type AbstractSampleCollection end

has_classes(collection::AbstractSampleCollection, field_name::AbstractString) = Py(collection).has_field(field_name)

get_classes(collection::AbstractSampleCollection, field_name::AbstractString) = Py(collection).get_classes(field_name)

has_mask_targets(collection::AbstractSampleCollection, field_name::AbstractString) = Py(collection).has_mask_targets(field_name)

get_mask_targets(collection::AbstractSampleCollection, field_name::AbstractString) = Py(collection).get_mask_targets(field_name)

has_skeleton(collection::AbstractSampleCollection, field_name::AbstractString) = Py(collection).has_skeleton(field_name)

get_skeleton(collection::AbstractSampleCollection, field_name::AbstractString) = Py(collection).get_skeleton(field_name)

stats(collection::AbstractSampleCollection; kwargs...) = Py(collection).stats(; kwargs...)

Base.first(collection::AbstractSampleCollection) = Sample(Py(collection).first())

Base.last(collection::AbstractSampleCollection) = Sample(Py(collection).last())

head(collection::AbstractSampleCollection, num_samples::Int = 3) = Sample.(Py(collection).head(num_samples))

tail(collection::AbstractSampleCollection, num_samples::Int = 3) = Sample.(Py(collection).tail(num_samples))

one(collection::AbstractSampleCollection, expr::ViewExpression; exact::Bool = false) = Sample(Py(collection).one(expr; exact))

save_context(collection::AbstractSampleCollection, batch_size::Union{Int, Nothing} = nothing) = Py(collection).save_context(batch_size)

get_field(collection::AbstractSampleCollection, path::AbstractString; kwargs...) = Py(collection).get_field(path; kwargs...)

get_dynamic_field_schema(collection::AbstractSampleCollection; kwargs...) = Py(collection).get_dynamic_field_schema(; kwargs...)

get_dynamic_frame_field_schema(collection::AbstractSampleCollection; kwargs...) = Py(collection).get_dynamic_frame_field_schema(; kwargs...)

make_unique_field_name(collection::AbstractSampleCollection; kwargs...) = Py(collection).make_unique_field_name(; kwargs...)

has_field(collection::AbstractSampleCollection, path::AbstractString) = Py(collection).has_field(path)

has_sample_field(collection::AbstractSampleCollection, path::AbstractString) = Py(collection).has_sample_field(path)

has_frame_field(collection::AbstractSampleCollection, path::AbstractString) = Py(collection).has_frame_field(path)

function validate_fields_exist(
    collection::AbstractSampleCollection, fields::Union{AbstractString, AbstractVector{<:AbstractString}}; include_private::Bool = false
)
    return Py(collection).validate_fields_exist(fields; include_private)
end

validate_field_type(collection::AbstractSampleCollection, path; kwargs...) = Py(collection).validate_field_type(path; kwargs...)

function tag_samples(collection::AbstractSampleCollection, tags::Union{AbstractString, AbstractVector{<:AbstractString}})
    return Py(collection).tag_samples(tags)
end

function untag_samples(collection::AbstractSampleCollection, tags::Union{AbstractString, AbstractVector{<:AbstractString}})
    return Py(collection).untag_samples(tags)
end

count_sample_tags(collection::AbstractSampleCollection) = Py(collection).count_sample_tags()

function tag_labels(collection::AbstractSampleCollection, tags::Union{AbstractString, AbstractVector{<:AbstractString}}; kwargs...)
    return Py(collection).tag_labels(tags; kwargs...)
end

function untag_labels(collection::AbstractSampleCollection, tags::Union{AbstractString, AbstractVector{<:AbstractString}}; kwargs...)
    return Py(collection).untag_labels(tags; kwargs...)
end

count_label_tags(collection::AbstractSampleCollection) = Py(collection).count_label_tags()

function split_labels(
    collection::AbstractSampleCollection,
    in_field::AbstractString,
    out_field::AbstractString;
    filter::Union{ViewExpression, Nothing} = nothing,
)
    return Py(collection).split_labels(in_field, out_field; filter)
end

function merge_labels(collection::AbstractSampleCollection, in_field::AbstractString, out_field::AbstractString)
    return Py(collection).merge_labels(in_field, out_field)
end

function set_values(collection::AbstractSampleCollection, field_name::AbstractString, values; kwargs...)
    return Py(collection).set_values(field_name, values; kwargs...)
end

function set_label_values(collection::AbstractSampleCollection, field_name::AbstractString, values; kwargs...)
    return Py(collection).set_label_values(field_name, values; kwargs...)
end

compute_metadata(collection::AbstractSampleCollection; kwargs...) = Py(collection).compute_metadata(; kwargs...)

apply_model(collection::AbstractSampleCollection, model; kwargs...) = Py(collection).apply_model(model; kwargs...)

compute_embeddings(collection::AbstractSampleCollection, model; kwargs...) = Py(collection).compute_embeddings(model; kwargs...)

function compute_patch_embeddings(collection::AbstractSampleCollection, model, patches_field::AbstractString; kwargs...)
    return Py(collection).compute_patch_embeddings(model, patches_field; kwargs...)
end

function evaluate_regressions(collection::AbstractSampleCollection, pred_field::AbstractString; kwargs...)
    return Py(collection).evaluate_regressions(pred_field; kwargs...)
end

function evaluate_classifications(collection::AbstractSampleCollection, pred_field::AbstractString; kwargs...)
    return Py(collection).evaluate_classifications(pred_field; kwargs...)
end

function evaluate_detections(collection::AbstractSampleCollection, pred_field::AbstractString; kwargs...)
    return Py(collection).evaluate_detections(pred_field; kwargs...)
end

function evaluate_segmentations(collection::AbstractSampleCollection, pred_field::AbstractString; kwargs...)
    return Py(collection).evaluate_segmentations(pred_field; kwargs...)
end

has_evaluation(collection::AbstractSampleCollection, eval_key) = Py(collection).has_evaluation(eval_key)

list_evaluations(collection::AbstractSampleCollection; kwargs...) = Py(collection).list_evaluations(; kwargs...)

rename_evaluation(collection::AbstractSampleCollection, eval_key, new_eval_key) = Py(collection).rename_evaluation(eval_key, new_eval_key)

get_evaluation_info(collection::AbstractSampleCollection, eval_key) = Py(collection).get_evaluation_info(eval_key)

function load_evaluation_results(collection::AbstractSampleCollection, eval_key; kwargs...)
    return Py(collection).load_evaluation_results(eval_key; kwargs...)
end

load_evaluation_view(collection::AbstractSampleCollection, eval_key; kwargs...) = Py(collection).load_evaluation_view(eval_key; kwargs...)

delete_evaluation(collection::AbstractSampleCollection, eval_key) = Py(collection).delete_evaluation(eval_key)

delete_evaluations(collection::AbstractSampleCollection) = Py(collection).delete_evaluations()

has_brain_run(collection::AbstractSampleCollection, brain_key) = Py(collection).has_brain_run(brain_key)

list_brain_runs(collection::AbstractSampleCollection; kwargs...) = Py(collection).list_brain_runs(; kwargs...)

rename_brain_run(collection::AbstractSampleCollection, brain_key, new_brain_key) = Py(collection).rename_brain_run(brain_key, new_brain_key)

get_brain_info(collection::AbstractSampleCollection, brain_key) = Py(collection).get_brain_info(brain_key)

load_brain_results(collection::AbstractSampleCollection, brain_key; kwargs...) = Py(collection).load_brain_results(brain_key; kwargs...)

load_brain_view(collection::AbstractSampleCollection, brain_key; kwargs...) = Py(collection).load_brain_view(brain_key; kwargs...)

delete_brain_run(collection::AbstractSampleCollection, brain_key) = Py(collection).delete_brain_run(brain_key)

delete_brain_runs(collection::AbstractSampleCollection) = Py(collection).delete_brain_runs()

# TODO Omitted ViewStage methods

# TODO Omitted aggregation methods

draw_labels(collection::AbstractSampleCollection, output_dir::AbstractString; kwargs...) = Py(collection).draw_labels(output_dir; kwargs...)

export_samples(collection::AbstractSampleCollection; kwargs...) = Py(collection).export(; kwargs...)

annotate(collection::AbstractSampleCollection, anno_key::AbstractString; kwargs...) = Py(collection).annotate(anno_key; kwargs...)

has_annotation_run(collection::AbstractSampleCollection, anno_key) = Py(collection).has_annotation_run(anno_key)

list_annotation_runs(collection::AbstractSampleCollection; kwargs...) = Py(collection).list_annotation_runs(; kwargs...)

function rename_annotation_run(collection::AbstractSampleCollection, anno_key, new_anno_key)
    return Py(collection).rename_annotation_run(anno_key, new_anno_key)
end

get_annotation_info(collection::AbstractSampleCollection, anno_key) = Py(collection).get_annotation_info(anno_key)

function load_annotation_results(collection::AbstractSampleCollection, anno_key; kwargs...)
    return Py(collection).load_annotation_results(anno_key; kwargs...)
end

load_annotation_view(collection::AbstractSampleCollection, anno_key; kwargs...) = Py(collection).load_annotation_view(anno_key; kwargs...)

load_annotations(collection::AbstractSampleCollection, anno_key; kwargs...) = Py(collection).load_annotations(anno_key; kwargs...)

delete_annotation_run(collection::AbstractSampleCollection, anno_key) = Py(collection).delete_annotation_run(anno_key)

delete_annotation_runs(collection::AbstractSampleCollection) = Py(collection).delete_annotation_runs()

list_indexes(collection::AbstractSampleCollection) = Py(collection).list_indexes()

get_index_information(collection::AbstractSampleCollection) = Py(collection).get_index_information()

create_index(collection::AbstractSampleCollection, field_or_spec; kwargs...) = Py(collection).create_index(field_or_spec; kwargs...)

drop_index(collection::AbstractSampleCollection, field_or_name) = Py(collection).drop_index(field_or_name)

reload(collection::AbstractSampleCollection) = Py(collection).reload()

to_dict(collection::AbstractSampleCollection; kwargs...) = Py(collection).to_dict(; kwargs...)

to_json(collection::AbstractSampleCollection; kwargs...) = Py(collection).to_json(; kwargs...)

write_json(collection::AbstractSampleCollection; kwargs...) = Py(collection).write_json(; kwargs...)

aggregate(collection::AbstractSampleCollection, aggregations) = Py(collection).aggregate(aggregations)
