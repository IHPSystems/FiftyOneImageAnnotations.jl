using FiftyOneImageAnnotations
using GeometryBasics
using Test

@testset "labels" begin
    @testset "Regression" begin
        @testset "Construction with confidence" begin
            regression = Regression(0.5; confidence = 0.6)
            @test regression.value == 0.5
            @test regression.confidence == 0.6
        end
        @testset "Construction without confidence" begin
            regression = Regression(0.5)
            @test regression.value == 0.5
            @test regression.confidence === nothing
        end
    end
    @testset "Classification" begin
        @testset "Construction with confidence and logits" begin
            classification = Classification("test"; confidence = 0.5, logits = [0.1, 0.2, 0.7])
            @test classification.label == "test"
            @test classification.confidence == 0.5
            @test classification.logits == [0.1, 0.2, 0.7]
        end
        @testset "Construction with confidence" begin
            classification = Classification("test"; confidence = 0.5)
            @test classification.label == "test"
            @test classification.confidence == 0.5
            @test classification.logits === nothing
        end
        @testset "Construction without confidence" begin
            classification = Classification("test")
            @test classification.label == "test"
            @test classification.confidence === nothing
            @test classification.logits === nothing
        end
    end
    @testset "Detection" begin
        @testset "Construction with confidence" begin
            detection = Detection("test", [0.1, 0.2, 0.9, 1.0]; confidence = 0.5)
            @test detection.label == "test"
            @test detection.bounding_box == [0.1, 0.2, 0.9, 1.0]
            @test detection.confidence == 0.5
        end
        @testset "Construction without confidence" begin
            detection = Detection("test", [0.1, 0.2, 0.9, 1.0])
            @test detection.label == "test"
            @test detection.bounding_box == [0.1, 0.2, 0.9, 1.0]
            @test detection.confidence === nothing
        end
        @testset "get_bounding_box" begin
            top_left = Point2(0.1, 0.2)
            size = Point2(0.9, 1.0)
            detection = Detection("test", [top_left..., size...])
            bounding_box = get_bounding_box(detection)
            @test bounding_box == Rect2(top_left, size)
        end
        @testset "get_height" begin
            top_left = Point2(0.1, 0.2)
            size = Point2(0.9, 1.0)
            detection = Detection("test", [top_left..., size...])
            height = get_height(detection)
            @test height == last(size)
        end
        @testset "get_top_left" begin
            top_left = Point2(0.1, 0.2)
            size = Point2(0.9, 1.0)
            detection = Detection("test", [top_left..., size...])
            actual_top_left = get_top_left(detection)
            @test actual_top_left == top_left
        end
        @testset "get_bottom_right" begin
            top_left = Point2(0.1, 0.2)
            size = Point2(0.9, 1.0)
            detection = Detection("test", [top_left..., size...])
            bottom_right = get_bottom_right(detection)
            @test bottom_right == top_left + size
        end
        @testset "get_width" begin
            top_left = Point2(0.1, 0.2)
            size = Point2(0.9, 1.0)
            detection = Detection("test", [top_left..., size...])
            width = get_width(detection)
            @test width == first(size)
        end
    end
end
