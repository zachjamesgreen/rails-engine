class String
  def zero?
    self == "0"
  end
end

class NilClass
  def zero?
    return false
  end
end