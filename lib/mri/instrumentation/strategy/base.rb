module Mri
  module Instrumentation
    module Strategy
      class Base
        
        attr_reader :probe,
                    :probes_collection
        
        def initialize( probe, probes_collection = [] )
          @probe = probe
          @probes_collection = probes_collection
        end
        
        # Script header.
        # Override for type declarations etc.
        #
        def header
          %[ #!/usr/sbin/dtrace -Zs 

             #pragma D option quiet\n ]
        end
        
        # Any strategy specific setup eg. runtime variables
        #
        def setup( contents = '')
          %[ dtrace:::BEGIN
              { 
          	    #{contents}
              }\n ]
        end
        
        # Probe entry definition
        #
        def entry( contents = '' )
          %[ #{function_entry}
          {
          	#{contents}
          }\n ]
        end
        
        # Any predicate conditions
        #
        def predicate
          ''
        end
        
        # Probe return definition
        #
        def return( contents = '' )
          %[ #{function_return}
             #{predicate}
          {
          	#{contents}
          }\n ]
        end  
        
        # Report results
        #
        def report( contents = '' )
          %[ dtrace:::END
              {
                #{contents}
              }\n ]
        end
        
        def method_missing( method, *args, &block )
          if @probe.respond_to?(method)
            @probe.send( method, *args, &block )
          else
            @probes_collection.send( method, *args, &block )
          end    
        end  
        
      end  
    end
  end
end