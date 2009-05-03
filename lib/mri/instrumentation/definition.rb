module Mri
  module Instrumentation
    class Definition
      
      # Represents a YAML probe definition
      #
      
      attr_reader :path,
                  :group,
                  :probes
      
      def initialize( path )
        @path = path
        @probes = []
        @group = setup_group()
        setup_probes()
      end  
      
      # Read and parse the definition
      #
      def read
        @read ||= YAML.load( IO.read( @path ) )
      end      
      
      private
        
        # Infer the group
        # 
        def setup_group
          @path.match( /([^\/|.]*).yml$/ )[1].to_sym
        end
        
        # Setup all probes
        #    
        def setup_probes
          read.each do |probe|
            probe.each_pair do |probe, definition|
              @probes << setup_probe( probe, 
                                      safe_definition( definition, "desc" ),
                                      safe_definition( definition, "arguments" ),
                                      safe_definition( definition, "return" ),
                                      safe_definition( definition, "storage" ) )
            end  
          end
        end
        
        # Don't assume all argument and return definitions is given
        #
        def safe_definition( definition, key )
          definition ? definition[key] : nil
        end  
      
        # Setup a single probe
        #
        def setup_probe( probe, description, arguments, returns, storage )
          Mri::Instrumentation::Probe.new( group, probe, description, setup_arguments( arguments ), returns, storage )
        end  
       
        # Setup arguments for a single probe
        #
        def setup_arguments( arguments )
          arguments_with_probe( arguments ).map do |argument|
            setup_argument( arguments, argument )
          end  
        end  
        
        # Setup a single argument
        #
        def setup_argument( arguments, argument )
          if argument.is_a?( Mri::Instrumentation::Argument )
            argument
          else  
            Mri::Instrumentation::Argument.new( argument.keys.first, argument.values.first, arguments.index(argument) )
          end
        end
       
        def arguments_with_probe( arguments )
          ( arguments || [] ) << Mri::Instrumentation::Argument.probe
        end
       
    end
  end
end