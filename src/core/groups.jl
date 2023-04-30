struct Group
    object::Py
end

PythonCall.ispy(group::Group) = true

PythonCall.Py(group::Group) = group.object
