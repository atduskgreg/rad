module ExternalVariableProcessing
  # issues 
  # testing 
  # add checking for colon

    
    ## need to clean this up
    ## need to test 
    def process_external_vars(klass)
      vars = eval "#{klass}.instance_variables"
      local_vars = []
      vars.each { |v| local_vars << ":#{v.gsub("@", "")}" }
      loc_vars = local_vars.join(", ")
      # add accessors 
      klass.module_eval "class << self; attr_accessor #{loc_vars} end"
      local_vars.each do |symbol|
        name = symbol.gsub(":","")
        t_var = eval "#{klass}.#{name}"
        pre_process_vars(name, t_var)
      end
    end
    
    
    def pre_process_vars(name, var)
        # puts 
        # puts
        case var
        when Integer
          # puts "pre_process: #{name}, #{var}, #{var.inspect} got #{var.class} 29"
          value = var
          type = "int"
          post_process_vars(name, type, value)
        when Float
          # puts "pre_process: #{name}, #{var}, #{var.inspect} got #{var.class} 34"
          value = var
          type = "float"
          post_process_vars(name, type, value)
        when String
          # puts "pre_process: #{name}, #{var.inspect} got #{var.class} on 39"
          if var.match(",").nil? && var =~ /long|byte|unsigned|int|short/
            # puts "pre_process #{name}, #{var.inspect} got #{var.class} level three sublevel"
            type = var
            value = nil
            post_process_vars(name, type, value)
          else
            value = var.split(",").first.lstrip
            type = var.split(",")[1].nil? ?  nil : var.split(",")[1].lstrip
            translate_variables( name , type, value )
          end
        when TrueClass
          # puts "pre_process: #{name}, #{var}, #{var.inspect} got #{var.class} on 50"
          value = 1
          type = "bool"
          post_process_vars(name, type, value)
        when FalseClass
          # puts "pre_process: #{name}, #{var}, #{var.inspect} got #{var.class} on 55"
          value = 0
          type = "bool"
          post_process_vars(name, type, value)
        when Array
          post_process_arrays(name, var)
        else
          raise ArgumentError, "not sure what to do here...  got #{name} with value #{var} which is a #{var.class}" 
        end      
    end     
    
    
    def translate_variables(name, type = nil, value = nil)
      
      unless type.nil?
        check_variable_type(type)
      end

      # classify the values
      if value.class == Fixnum 
        # puts "translate_variables: #{name}, #{value}, #{type} is a fixnum, got #{value.class} on 74"
      elsif value.class == Float 
        # puts "translate_variables: #{name}, #{value}, #{type} is a float, got #{value.class} on 76"
      elsif value =~ /^-(\d|x)*$/ 
        value = value.to_i
        type = "int" if type.nil?
      elsif value =~ /^-(\d|\.|x)*$/ 
        value = value.to_f
        unless type.nil?
          raise ArgumentError, "#{value} should be a float got  #{type}" unless type == "float"
        end
        type = "float" if type.nil?   

      elsif value[0,1] !~ /\d/
        # puts value[0,1]
        # puts "translate_variables: #{name}, #{value}, #{type} is a number of some type, got #{value.class} on 79"
        type = "char*"
        value = "\"#{value}\""
      elsif value !~ /(\.|x)/
        # puts "translate_variables: #{name}, #{value}, #{type} is an integer, got #{value.class} on 83"
        value = value.to_i
        type = "int" if type.nil?
      elsif value =~ /(\d*\.\d*)/ # and no 
        # puts "translate_variables: #{name}, #{value}, #{type} is a float, got #{value.class} on 87"
        value = value.to_f
        type = "float"
      elsif value =~ /0x\d\d/
        # puts "translate_variables: #{name}, #{value}, #{type} is a byte, got #{value.class} on 91"
        type = "byte"
      else
        raise ArgumentError, "not sure what to do with a value of #{value} with a type like #{type}" 
      end
     
      post_process_vars(name, type, value)
    end
    

    
    def post_process_vars(name, type, value = nil)
      value = " = #{value}" if value 
      $external_var_identifiers << "__#{name}" unless $external_var_identifiers.include?("__#{name}")
      $external_vars << "#{type} __#{name}#{value};"
    end
    
    def post_process_arrays(name, var)
      type = c_type(var[0])
      $array_types[name] = type
      assignment = var.inspect.gsub("[","{").gsub("]","}")      
      c_style_array = "#{type} __#{name}[] = #{assignment};"
      $external_var_identifiers << "__#{name}" unless $external_var_identifiers.include?("__#{name}")
      $external_array_vars << c_style_array unless $external_array_vars.include?(c_style_array)
    end
    
    def check_variable_type(type)
      unless type =~ /#{C_VAR_TYPES}/
        raise ArgumentError, "the following variable types are supported \n #{C_VAR_TYPES.gsub("|",", ")} got #{type}" 
      end
    end
    
    def c_type(typ)
      type = 
        case typ 
        when Integer
          "int"
        when String
          "char*"
        when TrueClass
          "bool"
        when FalseClass
          "bool"
        else
          raise "Bug! Unknown type #{typ.inspect} in c_type"
        end

        type
    end
   
end