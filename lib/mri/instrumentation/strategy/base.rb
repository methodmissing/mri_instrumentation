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
        def header( body = '' )
          %[ #!/usr/sbin/dtrace -ZFs 
             #pragma D option quiet\n
             #pragma D option dynvarsize=64m\n
             #{body}\n ]
        end
        
        # Any strategy specific setup eg. runtime variables
        #
        def setup( body = '')
          function_template( 'dtrace:::BEGIN', body )
        end
        
        # Probe entry definition
        #
        def entry( body = '' )
          function_template( function_entry, body )
        end
        
        # Probe function definition
        #
        def function( body = '' )
          function_template( @probe.function, body )
        end  
        
        # Any predicate conditions
        #
        def predicate
          ''
        end
        
        # Probe return definition
        #
        def return( body = '' )
          function_template( function_return, body, predicate )
        end  
        
        # Report results
        #
        def report( body = '' )
          function_template( 'dtrace:::END', body, '' )
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
        
        private
        
          def function_template( name, body, predicate_clause = '' )
            %[ #{name}
               #{predicate_clause}
               {
                 #{body}
                }\n ]            
          end
        
      end  
    end
  end
end