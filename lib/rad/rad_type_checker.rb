require 'ruby_to_ansi_c'

class RADTypeChecker < TypeChecker
  
  def process_const(exp)
    c = exp.shift
    if c.to_s =~ /^[A-Z]/ then
      # TODO: validate that it really is a const? 
      # uber hackery
      # since constants are defined in the arduino_sketch define method and 
      # we can't inject them into the methods 
      # transport them here with a $define_types hash

      $define_types.each do |k,v|
        if k == c.to_s
          @const_type = eval "Type.#{v}"
        end
      end
      return t(:const, c, @const_type)
    else
      raise "I don't know what to do with const #{c.inspect}. It doesn't look like a class."
    end
    raise "need to finish process_const in #{self.class}"
  end
  
end