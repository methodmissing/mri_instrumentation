module Mri
  module Instrumentation
    module Strategy
      class Interval < Base
        
        def header
          super %[ inline int SCREEN = 21;\n ]
        end
        
        def setup( contents = '' )
          super %[ #{init_counters()}
                   lines = SCREEN + 1;  ]          
        end
        
        def entry( contents = '' )
          %[ #{function_entry} 
             {
               #{probe.to_s}++;
              }\n ]  
        end
               
        def return( contents = '' )       
          ''            
        end              
                      
        def report( contents = '' )
          %[ profile:::tick-1sec
              {
              	printf("%20Y #{probes_collection.result_format}\\n", walltimestamp, #{probes_collection.to_s('', ', ')});

              	#{clear_counters}
              }\n ]
        end  
   
        # Build this strategy
        #
        def build
          %[ #{header}
             #{setup}
             #{print_header}
             #{yield}
             #{report} ]
        end
        
        
        private
                    
          def init_counters
            probes_collection.to_s( " = 0;", "\n" )
          end     
          alias :clear_counters :init_counters       
           
          def print_header
            %[ dtrace:::BEGIN,
              tick-1sec
              /lines++ > SCREEN/
              {
               	printf("#{probes_collection.format_string( '/s', ' ', :description )}\\n", #{probes_collection.description( '/s', ', ', '"' )});
              	lines = 0;
              }\n ]
          end   
        
      end
    end
  end
end