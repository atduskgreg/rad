require 'ruby_to_ansi_c'

class RADTypeChecker < TypeChecker
  
  def process_const(exp)
    c = exp.shift
    if c.to_s =~ /^[A-Z]/ then
      # TODO: validate that it really is a const? 
      ## make an executive decision, call it a string, since there is no lookup and
      ## the actual definition is handled by the arduio_sketch define method
      type = Type.str
      return t(:const, c, type)
    else
      raise "I don't know what to do with const #{c.inspect}. It doesn't look like a class."
    end
    raise "need to finish process_const in #{self.class}"
  end
  
end