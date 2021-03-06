module Mri
  module Instrumentation
    module Strategy
      class Speculate < Base

        def header
          super %[ #pragma D option flowindent ] 
        end
        
        def entry
          super %[ self->spec = speculation(); 
                   speculate(self->spec);
                   printf("#{probes_collection.format_string()}\\n", #{probes_collection.to_s( '/s', ', ', '"' )}); ]
        end
        
        def predicate
          '/self->spec/'
        end
        
        def return
          super %[ speculate(self->spec); 
                   trace(errno); ]
        end
        
        def predicate_success
          '/self->spec && errno == 0/'
        end

        def return_success
          body = %[ commit(self->spec);
                        self->spec = 0; ]
          function_template( function_return, body, predicate_success  )
        end

        def predicate_failure
          '/self->spec && errno != 0/'
        end
        
        def return_failure
          body = %[ discard(self->spec); 
                        self->spec = 0; ]
          function_template( function_return, body, predicate_failure  )          
        end
        
        def functions
          fncs = [:entry]
          fncs.concat( [:return_success, :return_failure] ) if @probe.return?
          fncs
        end        
        
      end
    end
  end
end