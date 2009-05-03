module Mri
  module Instrumentation
    module Strategy
      class Peek < Base
        
        def header
          super %[ #pragma D option flowindent ]
        end

        def predicate_guarded_entry
          '/guard++ == 0/'
        end

        def guarded_entry
          contents = %[ self->peek = 1;
                        #{assign_arguments}
                        printf( "#{@probe.format_string}", #{@probe.arguments_list} ); ]
          function_template( @probe.function_entry, contents, predicate_guarded_entry  )
        end
        
        def peek
          function_template( @probe.wildcard, '', predicate  )          
        end
        
        def predicate
          "/self->peek/"
        end
        
        def return
          super %[ self->peek = 0;
                   exit(0); ]
        end
        
        def functions
          fncs = [:guarded_entry]
          fncs.concat( [:peek, :return] ) if @probe.return?
          fncs
        end                
        
      end  
    end
  end
end