class Object
  def my_methods
    (methods - Object.instance_methods).sort
  end
end
