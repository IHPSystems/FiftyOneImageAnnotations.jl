using FiftyOneImageAnnotations
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
end
