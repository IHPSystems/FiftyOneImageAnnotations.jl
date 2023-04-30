module FiftyOneImageAnnotations

using PythonCall

const fiftyone = PythonCall.pynew()

function __init__()
    PythonCall.pycopy!(fiftyone, pyimport("fiftyone"))
    return nothing
end

include(joinpath(@__DIR__, "util", "data", "importers.jl"))
include(joinpath(@__DIR__, "util", "data", "parsers.jl"))

include(joinpath(@__DIR__, "core", "collections.jl"))
include(joinpath(@__DIR__, "core", "fields.jl"))
include(joinpath(@__DIR__, "core", "frame.jl"))
include(joinpath(@__DIR__, "core", "groups.jl"))
include(joinpath(@__DIR__, "core", "sample.jl"))
include(joinpath(@__DIR__, "core", "view.jl"))
include(joinpath(@__DIR__, "core", "dataset.jl"))
include(joinpath(@__DIR__, "core", "dataset_exports.jl"))

end
