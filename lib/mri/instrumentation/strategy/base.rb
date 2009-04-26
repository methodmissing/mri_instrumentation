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
          %[ #!/usr/sbin/dtrace -ZFs 
             #pragma D option quiet\n
             #pragma D option dynvarsize=64m\n
             #{contents}\n ]
        end
        
        # Any strategy specific setup eg. runtime variables
        #
        def setup( contents = '')
          function_template( 'dtrace:::BEGIN', contents )
        end
        
        # Probe entry definition
        #
        def entry( contents = '' )
          function_template( function_entry, contents )
        end
        
        # Probe function definition
        #
        def function( contents = '' )
          function_template( @probe.function, contents )
        end  
        
        # Any predicate conditions
        #
        def predicate
          ''
        end
        
        # Probe return definition
        #
        def return( contents = '' )
          function_template( function_return, contents, predicate )
        end  
        
        # Report results
        #
        def report( contents = '' )
          function_template( 'dtrace:::END', contents, '' )
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
        
          def function_template( name, contents, predicate_clause = '' )
            %[ #{name}
               #{predicate_clause}
               {
                 #{contents}
                }\n ]            
          end
        
      end  
    end
  end
end