function to_label(a::BoundingBoxAnnotation{String, T}, image_size::Tuple{Int, Int})::Py where {T}
    rect = get_bounding_box(a)
    return fiftyone.core.labels.Detection(;
        label = get_label(a),
        bounding_box = ((rect.origin.data ./ image_size)..., (rect.widths.data ./ image_size)...),
        confidence = get_confidence(a),
    )
end

function to_label(a::BoundingBoxAnnotation{Label{String}, T}, image_size::Tuple{Int, Int})::Py where {T}
    label = get_label(a)
    rect = get_bounding_box(a)
    result = fiftyone.core.labels.Detection(;
        label = label.value,
        bounding_box = ((rect.origin.data ./ image_size)..., (rect.widths.data ./ image_size)...),
        confidence = get_confidence(a),
    )
    for (k, v) in label.attributes
        result.set_attribute_value(k, v)
    end
    return result
end

function to_label(a::ImageAnnotation{Label{String}})::Py
    label = get_label(a)
    result = fiftyone.core.labels.Classification(; label = label.value, confidence = get_confidence(a))
    for (k, v) in label.attributes
        result.set_attribute_value(k, v)
    end
    return result
end

function to_label(a::OrientedBoundingBoxAnnotation{Label{String}, T}, image_size::Tuple{Int, Int})::Py where {T}
    label = get_label(a)
    points = collect(map(v -> (Float64(v[1]), Float64(v[2])) ./ image_size, get_vertices(a)))
    shapes = [points]
    result = fiftyone.core.labels.Polyline(;
        label = label.value, points = shapes, confidence = get_confidence(a), closed = true, filled = true
    )
    for (k, v) in label.attributes
        result.set_attribute_value(k, v)
    end
    return result
end

function to_label(a::PolygonAnnotation{Label{String}, T}, image_size::Tuple{Int, Int})::Py where {T}
    label = get_label(a)
    points = collect(map(v -> (Float64(v[1]), Float64(v[2])) ./ image_size, get_vertices(a)))
    shapes = [points]
    result = fiftyone.core.labels.Polyline(;
        label = label.value, points = shapes, confidence = get_confidence(a), closed = true, filled = true
    )
    for (k, v) in label.attributes
        result.set_attribute_value(k, v)
    end
    return result
end

function define_image_annotation_dataset_importer()
    return pytype(
        "ImageAnnotationDatasetImporter",
        (fiftyone.utils.data.LabeledImageDatasetImporter,),
        [
            "__module__" => "__main__",
            pyfunc(
                function (self, dataset; shuffle = false, seed = nothing, max_samples = nothing, data_path = nothing)
                    pybuiltins.super(self.__class__, self).__init__(; shuffle = shuffle, seed = seed, max_samples = max_samples)
                    self.dataset = dataset
                    self.data_path = data_path
                    self._iter_annotated_images = pyiter(dataset)
                    return nothing
                end;
                name = "__init__",
            ),
            pyfunc(
                self -> "ImageAnnotationDatasetImporter($(self.dataset), $(self.shuffle), $(self.seed), $(self.max_samples))";
                name = "__repr__",
            ),
            pyfunc(function (self)
                self._iter_annotated_images = pyiter(self.dataset), return self
            end; name = "__iter__"),
            pyfunc(self -> length(self.dataset); name = "__len__"),
            pyfunc((self, i) -> self.dataset[i]; name = "__getitem__"),
            pyfunc(
                function (self)
                    annotated_image = pynext(self._iter_annotated_images)
                    if annotated_image === nothing
                        pythrow(pybuiltins.StopIteration())
                    end

                    image_file_path = normpath(string(self.data_path), string(annotated_image.image_file_path))

                    image_metadata = nothing
                    if annotated_image.image_width !== nothing || annotated_image.image_height !== nothing
                        image_metadata = fiftyone.core.metadata.ImageMetadata(;
                            width = annotated_image.image_width, height = annotated_image.image_height
                        )
                    end

                    if isempty(annotated_image.annotations)
                        labels = nothing
                    else
                        labels = pydict()
                        image_size = pyconvert.(Int, (annotated_image.image_width, annotated_image.image_height))
                        annotations = map(a -> pyconvert(Any, a), annotated_image.annotations)
                        bounding_box_annotations = filter(a -> a isa BoundingBoxAnnotation, annotations)
                        if !isempty(bounding_box_annotations)
                            bounding_box_labels = collect(map(a -> to_label(a, image_size), bounding_box_annotations))
                            labels["detections"] = fiftyone.core.labels.Detections(; detections = bounding_box_labels)
                        end
                        image_annotations = filter(a -> a isa ImageAnnotation, annotations)
                        if !isempty(image_annotations)
                            classification_labels = collect(map(to_label, image_annotations))
                            labels["classifications"] = fiftyone.core.labels.Classifications(; classifications = classification_labels)
                        end
                        polygonish_annotations = filter(a -> a isa OrientedBoundingBoxAnnotation || a isa PolygonAnnotation, annotations)
                        if !isempty(polygonish_annotations)
                            polygon_labels = collect(map(a -> to_label(a, image_size), polygonish_annotations))
                            labels["polylines"] = fiftyone.core.labels.Polylines(; polylines = polygon_labels)
                        end
                    end

                    return image_file_path, image_metadata, labels
                end;
                name = "__next__",
            ),
            "has_dataset_info" => pyproperty(; get = (self) -> false),
            "has_image_metadata" => pyproperty(; get = (self) -> true),
            "label_cls" => pyproperty(;
                get = (self) -> pydict(
                    Dict(
                        "classifications" => fiftyone.core.Labels.Classifications,
                        "regression" => fiftyone.core.Labels.Regression,
                        "detections" => fiftyone.core.Labels.Detections,
                        "polylines" => fiftyone.core.labels.Polylines,
                    ),
                ),
            ),
            pyfunc(self -> nothing; name = "setup"),
            pyfunc(self -> error("Not supported"); name = "get_dataset_info"),
            pyfunc((self, args...) -> nothing; name = "close"),
        ],
    )
end

function define_image_annotation_dataset_type()
    return pytype(
        "ImageAnnotationDatasetType",
        (fiftyone.types.LabeledImageDataset,),
        [
            "__module__" => "__main__",
            pyfunc(self -> ImageAnnotationDatasetImporter; name = "get_dataset_importer_cls"),
            pyfunc(self -> error("Not supported"); name = "get_dataset_exporter_cls"),
        ],
    )
end
