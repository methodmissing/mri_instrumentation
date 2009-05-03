module Mri
  module Instrumentation
    module Strategy
      class Flow < Base
        
        def header
          super %[ #pragma D option switchrate=5\n
                   self int depth;\n ]
        end        
        
        def setup
          super %[ printf("#{probes_collection.format_string( '', ' ', :description )}\\n", #{probes_collection.description( '', ', ', '"' )});\n
                   self->depth = 0;\n ]
        end  
        
        def entry
          super %[ printf("%3d %-16d %*s %-22s ->\\n", cpu, timestamp / 1000, self->depth * 2, "", probefunc );\n
           self->depth++; ]
        end

        def return
          super %[ self->depth--;
                   printf("%3d %-16d %*s %-22s <-\\n", cpu, timestamp / 1000, self->depth * 2, "", probefunc );\n ]
        end
        
        def report
          super %[ exit(0); ]
        end
        
      end
    end
  end  
end