module Mri
  module Instrumentation
    module Strategy
      class Stack < Base
        
        def predicate_guarded_entry
          ""
        end

        def guarded_entry
          contents = %[ self->stack = 1;
                        #{copy_arguments} ]
          function_template( @probe.function_entry, contents, predicate_guarded_entry  )
        end
        
        def stack
          function_template( @probe.wildcard, '', predicate  )          
        end
        
        def predicate
          "/self->stack/"
        end
        
        def return
          super %[ #{assign_arguments}
                   printf( "#{@probe.format_string}", #{@probe.arguments_list} );
                   self->stack = 0;
                   ustack();
                   exit(0); ]
        end
        
        def functions
          fncs = [:guarded_entry]
          fncs.concat( [:stack, :return] ) if @probe.return?
          fncs
        end                
        
      end  
    end
  end
end