struct ViewExpression
    object::Py
end

PythonCall.ispy(view_expression::ViewExpression) = true

PythonCall.Py(view_expression::ViewExpression) = view_expression.object
