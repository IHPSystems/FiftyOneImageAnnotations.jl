using FiftyOneImageAnnotations
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
    end
end
