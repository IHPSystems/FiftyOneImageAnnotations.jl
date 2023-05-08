module FiftyOneImageAnnotations

using PythonCall

const fiftyone = PythonCall.pynew()

function __init__()
    PythonCall.pycopy!(fiftyone, pyimport("fiftyone"))
    return nothing
end

end
