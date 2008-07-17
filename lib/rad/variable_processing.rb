module ExternalVariableProcessing
  # issues
  # testing

  
  # 
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    
    ## need to clean this up
    def inherited(subclass)
      eval File.read($sketch_file_location)
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
        value = var.split(",").first.lstrip
        type = var.split(",")[1].nil? ?  nil : var.split(",")[1].lstrip
		    translate_variables( name , value, type  )
      end
    end
    
    
    def translate_variables(name, value = nil, type =nil)
      unless type.nil?
        check_variable_type(type)
      end
      
      puts 
      puts "name: #{name}, value: #{value},  type: #{type}"
      $external_vars ||= []
      $external_var_identifiers ||= []
      value = "= #{value}" if value
      unless type
        type = case value
        when Integer
          "int"
        when String
          "char*"
        when TrueClass
          "bool"
        when FalseClass
          "bool"
        end
      end
      $external_vars << "#{type} #{name} #{value}"
      $external_var_identifiers << name unless $external_var_identifiers.include?(name) 
    end
    
    def check_variable_type(type)
      unless type =~ /#{PLUGIN_C_VAR_TYPES}/
        raise ArgumentError, "the following variable types are supported \n #{PLUGIN_C_VAR_TYPES.gsub("|",", ")} got #{type}" 
      end
    end
    
    
  end
end