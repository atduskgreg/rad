require 'ruby_to_ansi_c'

class RADProcessor < RubyToAnsiC

  def self.translator
    unless defined? @translator then
      @translator = CompositeSexpProcessor.new
      @translator << RADRewriter.new
      @translator << TypeChecker.new
      @translator << R2CRewriter.new
      @translator << self.new
      @translator.on_error_in(:defn) do |processor, exp, err|
        result = processor.expected.new
        case result
        when Array then
          result << :error
        end
        msg = "// ERROR: #{err.class}: #{err}"
        msg += " in #{exp.inspect}" unless exp.nil? or $TESTING
        msg += " from #{caller.join(', ')}" unless $TESTING
        result << msg
        result
      end
    end
    @translator
  end
  
  def process_iasgn(exp)
    name = exp.shift
    val = process exp.shift
    "__#{name.to_s.sub(/^@/, '')} = #{val}"
  end
    
  def process_lasgn(exp)
    out = ""

    var = exp.shift
    value = exp.shift
    # grab the size of the args, if any, before process converts to a string
    arg_count = 0
    arg_count = value.length - 1 if value.first == :array
    args = value

    exp_type = exp.sexp_type
    @env.add var.to_sym, exp_type
    var_type = self.class.c_type exp_type

    if exp_type.list? then
      assert_type args, :array

      raise "array must be of one type" unless args.sexp_type == Type.homo

      # HACK: until we figure out properly what to do w/ zarray
      # before we know what its type is, we will default to long.
      array_type = args.sexp_types.empty? ? 'void *' : self.class.c_type(args.sexp_types.first)
      # we can fix array here..
      args.shift # :arglist
      out << "#{var} = (#{array_type}) malloc(sizeof(#{array_type}) * #{args.length});\n"
      args.each_with_index do |o,i|
        out << "#{var}[#{i}] = #{process o};\n"
      end
    else
      out << "#{var} = #{process args}"
    end

    out.sub!(/;\n\Z/, '')

    return out
  end


end