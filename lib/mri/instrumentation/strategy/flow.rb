module Mri
  module Instrumentation
    module Strategy
      class Flow < Base
        
        def header
          super %[ #pragma D option switchrate=10\n
                   self int depth;\n ]
        end        
        
        def setup
          super %[ printf("#{probes_collection.format_string( '/s' )}\\n", #{probes_collection.to_s( '/s', ', ', '"' )});\n ]
        end  
        
        def entry
          super %[ printf("%3d %-16d %-22s %*s->\\n", cpu, timestamp / 1000, 
probefunc, self->depth * 2, "" );\n ]
        end

        def return
          super %[ printf("%3d %-16d %-22s %*s<-\\n", cpu, timestamp / 1000, 
        probefunc, self->depth * 2, "" );\n ]
        end
        
      end
    end
  end  
end