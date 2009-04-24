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
        def header( contents = '' )
          %[ #!/usr/sbin/dtrace -Zs 
             #pragma D option quiet\n
             #pragma D option dynvarsize=64m\n
             #{contents}\n ]
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
        
        # Probe function definition
        #
        def function( contents = '' )
          %[ #{@probe.function}
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
        
        # Build this strategy
        #
        def build
          %[ #{header}
             #{setup}
             #{yield}
             #{report} ]
        end
        
        # The function definitions to build out
        #
        def functions
          fncs = [:entry]
          fncs << :return unless void?
          fncs
        end
        
        # Respect methods on the probe collection first, then cascade down to the
        # current probe definition if any.
        #
        def method_missing( method, *args, &block )
          if @probes_collection.respond_to?(method)
            @probes_collection.send( method, *args, &block )
          else
            @probe.send( method, *args, &block )
          end    
        end  
        
      end  
    end
  end
end