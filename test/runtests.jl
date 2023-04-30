using Test

@testset "FiftyOneImageAnnotations" begin
    include(joinpath(@__DIR__, "core", "dataset_tests.jl"))
end
