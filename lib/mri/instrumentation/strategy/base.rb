module Mri
  module Instrumentation
    module Strategy
      class Base
        
        attr_reader :probe
        
        def initialize( probe )
          @probe = probe
        end
        
        def header
          %[ #!/usr/sbin/dtrace -Zs 

             #pragma D option quiet\n ]
        end
        
        def setup( contents = '' )
          %[ dtrace:::BEGIN
              { 
          	    #{contents}
              }\n ]
        end
        
        def entry( contents = '' )
          %[ #{function_entry}
          {
          	#{contents}
          }\n ]
        end
        
        def predicate
          ''
        end
        
        def return( contents = '' )
          %[ #{function_return}
             #{predicate}
          {
          	#{contents}
          }\n ]
        end  
        
        def report( contents = '' )
          %[ dtrace:::END
              {
                #{contents}
              }\n ]
        end
        
        def method_missing( method, *args, &block )
          @probe.send( method, *args, &block )
        end  
        
      end  
    end
  end
end