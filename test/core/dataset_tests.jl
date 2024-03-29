using FiftyOneImageAnnotations
using GeometryBasics
using ImageAnnotations
using PythonCall
using Test

@testset "Dataset" begin
    @warn "These tests will delete non-persistent datasets."
    function setupteardown(f::Function)
        @assert list_datasets() == String[]
        try
            f()
        finally
            delete_non_persistent_datasets()
            @assert list_datasets() == String[]
        end
    end
    @testset "constructor" begin
        setupteardown() do
            a = Dataset("foo")
            b = Dataset("bar"; persistent = true)
            c = Dataset()
            @test length(list_datasets()) == 3
            b.persistent = false
        end
    end
    @testset "list_datasets" begin
        setupteardown() do
            @test list_datasets() == []
            dataset = Dataset("foo")
            @test list_datasets() == ["foo"]
        end
    end
    @testset "dataset_exists" begin
        setupteardown() do
            @test !dataset_exists("foo")
            dataset = Dataset("foo")
            @test dataset_exists("foo")
        end
    end
    @testset "load_dataset" begin
        setupteardown() do
            @test_throws Exception load_dataset("foo")
            dataset = Dataset("foo")
            @test dataset == load_dataset("foo")
        end
    end
    @testset "delete_dataset" begin
        setupteardown() do
            @test_throws Exception delete_dataset("foo")
            dataset = Dataset("foo")
            delete_dataset("foo")
        end
    end
    @testset "delete_datasets" begin
        setupteardown() do
            Dataset("foo")
            Dataset("bar")
            Dataset("baz")
            delete_datasets("ba*")
            @test list_datasets() == ["foo"]
        end
    end
    @testset "delete_non_persistent_datasets" begin
        setupteardown() do
            foo = Dataset("foo"; persistent = true)
            bar = Dataset("bar")
            delete_non_persistent_datasets()
            @test list_datasets() == ["foo"]
            foo.persistent = false
        end
    end
    @testset "dataset_from_importer" begin
        @testset "Empty dataset" begin
            setupteardown() do
                dataset = ImageAnnotationDataSet(AnnotatedImage[])
                fo_dataset = dataset_from_importer(ImageAnnotationDatasetImporter(dataset); name = "foo")
                @test fo_dataset.name == "foo"
                @test isempty(fo_dataset)
            end
        end
        @testset "BoundingBoxAnnotation imported as Detection" begin
            setupteardown() do
                image_size = 2
                dataset = ImageAnnotationDataSet([
                    AnnotatedImage(
                        BoundingBoxAnnotation(Point2(0.1, 0.2), 0.3, 0.4, Label("test"));
                        image_width = image_size,
                        image_height = image_size,
                    ),
                ])
                fo_dataset = dataset_from_importer(ImageAnnotationDatasetImporter(dataset; bounding_box_annotation_type = Detection))
                @test length(fo_dataset) == 1
                sample = first(fo_dataset)
                @test pyis(pytype(sample.object["detections"]), FiftyOneImageAnnotations.fiftyone.core.labels.Detections)
            end
        end
        @testset "BoundingBoxAnnotation imported as Polyline" begin
            setupteardown() do
                image_size = 2
                dataset = ImageAnnotationDataSet([
                    AnnotatedImage(
                        BoundingBoxAnnotation(Point2(0.1, 0.2), 0.3, 0.4, Label("test"));
                        image_width = image_size,
                        image_height = image_size,
                    ),
                ])
                fo_dataset = dataset_from_importer(ImageAnnotationDatasetImporter(dataset; bounding_box_annotation_type = Polyline))
                @test length(fo_dataset) == 1
                sample = first(fo_dataset)
                @test pyis(pytype(sample.object["polylines"]), FiftyOneImageAnnotations.fiftyone.core.labels.Polylines)
            end
        end
    end
    @testset "export_samples" begin
        @testset "Empty dataset" begin
            setupteardown() do
                dataset = ImageAnnotationDataSet(AnnotatedImage[])
                fo_dataset = dataset_from_importer(ImageAnnotationDatasetImporter(dataset); name = "foo")
                exported_dataset = export_samples(fo_dataset, ImageAnnotationDatasetExporter)
                @test exported_dataset == dataset
            end
        end
        @testset "BoundingBoxAnnotation with confidence" begin
            setupteardown() do
                image_size = 2
                data_path = pwd()
                dataset = ImageAnnotationDataSet([
                    AnnotatedImage(
                        BoundingBoxAnnotation(Point2(0.1, 0.2), 0.3, 0.4, Label("test"); confidence = 0.6f0);
                        image_file_path = "img.jpeg",
                        image_width = image_size,
                        image_height = image_size,
                    ),
                ])
                fo_dataset = dataset_from_importer(ImageAnnotationDatasetImporter(dataset; data_path))
                exported_dataset = export_samples(fo_dataset, ImageAnnotationDatasetExporter; data_path)
                @test exported_dataset == dataset
            end
        end
    end
end
