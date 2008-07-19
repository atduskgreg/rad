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
        puts
        puts
        case var
        when Integer
          puts "pre_process #{name}, #{var}, #{var.inspect} got #{var.class} level one"
          value = var
          type = "int"
          post_process_vars(name, type, value)
        when Float
          puts "pre_process #{name}, #{var}, #{var.inspect} got #{var.class} level one"
          value = var
          type = "float"
          post_process_vars(name, type, value)
        when String
          puts "pre_process #{name}, #{var.inspect} got #{var.class} level three"
          if var.match(",").nil? && var =~ /long|byte|unsigned|int|short/
            puts "pre_process #{name}, #{var.inspect} got #{var.class} level three sublevel"
            type = var
            value = nil
            post_process_vars(name, type, value)
          else
          end
          value = var.split(",").first.lstrip
          type = var.split(",")[1].nil? ?  nil : var.split(",")[1].lstrip
          translate_variables( name , type, value )
        when TrueClass
          puts "pre_process #{name}, #{var}, #{var.inspect} got #{var.class} level one"
          value = var
          type = "bool"
          post_process_vars(name, type, value)
        when FalseClass
          puts "pre_process #{name}, #{var}, #{var.inspect} got #{var.class} level one"
          value = var
          type = "bool"
          post_process_vars(name, type, value)
        else
          raise ArgumentError, "error message here.. got #{name}" 
        end
		    
      
    end     
    
    
    def translate_variables(name, type = nil, value = nil)
      # this is actually string processing, since that is all the should be coming here..
      puts "translating #{name}, #{type}, #{value}"
      
      unless type.nil?
        check_variable_type(type)
      end

      if value.class == Fixnum 
        puts "think #{name}, #{value} is a fixnum, got #{value.class} level 1"
      elsif value.class == Float 
          puts "think #{name}, #{value} is a float, got #{value.class} level 2"
      elsif value[0,1] !~ /\d/
        puts value[0,1]
        puts "think #{name}, #{value} is a string, got #{value.class} level 3"
        value = process_string(value) 
      elsif value !~ /(\.|x)/
        puts "think #{name}, #{value} is an integer, got #{value.class} level 4"
        value = value.to_i
      elsif value =~ /(\d*\.\d*)/ # and no 
        puts "think #{name}, #{value} is a float, got #{value.class} level 5"
        value = value.to_f
      elsif value =~ /0x\d\d/
        puts "think #{name}, #{value} is a byte, got #{value.class} level 6"
        type = "byte"
      else
        raise ArgumentError, "don't think the value is a string, integer, float or byte, got #{value} level 7" 
      end
     
      unless type
        # puts "testing the type of #{value} which we think is #{value.class}"
        # need to test for double
        # and others?
        type = case value
        when Integer
          "int"
        when Float
          "float"
        when String
          "char*"
        when TrueClass
          "bool"
        when FalseClass
          "bool"
        end
      end

      post_process_vars(name, type, value)
    end
    
    def post_process_vars(name, type, value = nil)
      value = " = #{value}" if value
      # need to test the ... also... 
      $external_var_identifiers << "__#{name}" unless $external_var_identifiers.include?("__#{name}")
      $external_vars << "#{type} __#{name}#{value};"
    end
    
    def process_string(string)
      puts "got #{string}"
      
      
      "\"#{string}\""
    
    
    end
    
    def check_variable_type(type)
      unless type =~ /#{PLUGIN_C_VAR_TYPES}/
        raise ArgumentError, "the following variable types are supported \n #{PLUGIN_C_VAR_TYPES.gsub("|",", ")} got #{type}" 
      end
      # now we need to do something...
    end
   
end