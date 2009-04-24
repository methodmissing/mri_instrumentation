module Mri
  module Instrumentation
    module Strategy
      class Calls < Base
        
        def setup
          super %[ printf("Tracing... Hit Ctrl-C to end.\\n");\n ]          
        end

        def function
          super %[ #{assign_arguments}
                   @calls[#{arguments_list( arguments_size )}] = count(); ]
        end 

        def functions
          [:function]
        end

        def report
          super %[ printf(" #{header_format}\\n", #{report_header}, "CALLS");
     	   printa(" #{report_format}\\n", @calls); ]  
        end        
        
      end
    end
  end
end