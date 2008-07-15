require 'ruby_to_ansi_c'

class RADRewriter < Rewriter
  
  def process_iter(exp)
    call = process exp.shift
    var  = process exp.shift
    body = process exp.shift

    var = s(:dasgn_curr, Unique.next) if var.nil?

    assert_type call, :call

    if call[2] != :each then # TODO: fix call[n] (api)
      call.shift # :call
      lhs = call.shift
      method_name = call.shift

      case method_name
      when :downto then
        var.shift # 
        start_value = lhs
        finish_value = call.pop.pop # not sure about this
        var_name = var.shift
        body.find_and_replace_all(:dvar, :lvar)
        result = s(:dummy,
                   s(:lasgn, var_name, start_value),
                   s(:while,
                     s(:call, s(:lvar, var_name), :>=,
                       s(:arglist, finish_value)),
                     s(:block,
                       body,
                       s(:lasgn, var_name,
                         s(:call, s(:lvar, var_name), :-,
                           s(:arglist, s(:lit, 1))))), true))
      when :upto then
        # REFACTOR: completely duped from above and direction changed
        var.shift # 
        start_value = lhs
        finish_value = call.pop.pop # not sure about this
        var_name = var.shift
        body.find_and_replace_all(:dvar, :lvar)
        result = s(:dummy,
                   s(:lasgn, var_name, start_value),
                   s(:while,
                     s(:call, s(:lvar, var_name), :<=,
                       s(:arglist, finish_value)),
                     s(:block,
                       body,
                       s(:lasgn, var_name,
                         s(:call, s(:lvar, var_name), :+,
                           s(:arglist, s(:lit, 1))))), true))
       when :times then
         # REFACTOR: mostly duped from above and gave default start value of 0
         # and a finish value that was the start value above
         var.shift 
         start_value = s(:lit, 0)
         finish_value = lhs
         var_name = var.shift
         body.find_and_replace_all(:dvar, :lvar)
         result = s(:dummy,
                    s(:lasgn, var_name, start_value),
                    s(:while,
                      s(:call, s(:lvar, var_name), :<,
                        s(:arglist, finish_value)),
                      s(:block,
                        body,
                        s(:lasgn, var_name,
                          s(:call, s(:lvar, var_name), :+,
                            s(:arglist, s(:lit, 1))))), true))
      when :define_method then
        # BEFORE: [:iter, [:call, nil, :define_method, [:array, [:lit, :bmethod_added]]], [:dasgn_curr, :x], [:call, [:dvar, :x], :+, [:array, [:lit, 1]]]]
        # we want to get it rewritten for the scope/block context, so:
        #   - throw call away
        #   - rewrite to args
        #   - plop body into a scope
        # AFTER:  [:block, [:args, :x], [:call, [:lvar, :x], :+, [:arglist, [:lit, 1]]]]
        var.find_and_replace_all(:dasgn_curr, :args)
        body.find_and_replace_all(:dvar, :lvar)
        result = s(:block, var, body)
      else
        # HACK we butchered call up top
        result = s(:iter, s(:call, lhs, method_name, call.shift), var, body)
      end
    else
      if var.nil? then
        var = s(:lvar, Unique.next)
      end

      s(:iter, call, var, body)
    end
  end

end