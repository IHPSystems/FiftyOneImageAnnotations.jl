struct Frame
    object::Py
end

PythonCall.ispy(frame::Frame) = true

PythonCall.Py(frame::Frame) = frame.object
