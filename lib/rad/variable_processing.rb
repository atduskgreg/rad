module ExternalVariableProcessing
  # issues
  # testing
  # add checking for colon

    
    ## need to clean this up
    ## need to test 
    def process_external_vars(subclass)
      vars = eval "#{subclass}.instance_variables"
      local_vars = []
      vars.each { |v| local_vars << ":#{v.gsub("@", "")}" }
      loc_vars = local_vars.join(", ")
      # add accessors
      subclass.module_eval "class << self; attr_accessor #{loc_vars} end"
      assemble_the_vars(subclass, local_vars)
    end
    
    def assemble_the_vars(subclass, vars)
      vars.each do |symbol| 
        name = symbol.gsub(":","")
        var = eval "#{subclass}.#{name}" 
        # if integer or float, then skip this
        if var.class == Fixnum || Float || Bignum
          puts "we see #{var} and think it is a #{var.class}"
          value = var
          type = nil
        else
          value = var.split(",").first.lstrip
          type = var.split(",")[1].nil? ?  nil : var.split(",")[1].lstrip
        end
		    translate_variables( name , value, type  )
      end
    end
    
    # need testing
    def translate_variables(name, value = nil, type =nil)
      unless type.nil?
        check_variable_type(type)
      end
      
      # puts 
      # puts "name: #{name}, value: #{value},  type: #{type}"
      $external_vars ||= []
      $external_var_identifiers ||= []
      # check for int and float
      if value.class == Fixnum 
        puts "think #{value} is a fixnum, got #{value.class}"
      elsif value.class == Float 
          puts "think #{value} is a float, got #{value.class}"
      elsif value[0,1] !~ /\d/
        puts value[0,1]
        puts "think #{value} is a string, got #{value.class}"
        value = process_string(value) 
      elsif value !~ /(\.|x)/
        puts "think #{value} is an integer, got #{value.class}"
        value = value.to_i
      elsif value =~ /(\d*\.\d*)/ # and no 
        puts "think #{value} is a float, got #{value.class}"
        value = value.to_f
      elsif value =~ /0x\d\d/
        puts "think #{value} is a byte, got #{value.class}"
      else
        raise ArgumentError, "don't think the value is a string, integer, float or byte, got #{value}" 
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
      value = "= #{value}" if value
      $external_vars << "#{type} __#{name} #{value};"
      $external_var_identifiers << "__#{name}" unless $external_var_identifiers.include?("__#{name}") 
    end
    
    def process_string(string)
      puts "got #{string}"
      "\"#{string}\""
    end
    
    def check_variable_type(type)
      unless type =~ /#{PLUGIN_C_VAR_TYPES}/
        raise ArgumentError, "the following variable types are supported \n #{PLUGIN_C_VAR_TYPES.gsub("|",", ")} got #{type}" 
      end
    end
   
end