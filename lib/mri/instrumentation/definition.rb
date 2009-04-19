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
          read.each_pair do |probe, arguments|
            @probes << setup_probe( probe, arguments )
          end  
        end
      
        # Setup a single probe
        #
        def setup_probe( probe, arguments )
          Mri::Instrumentation::Probe.new( group, probe, setup_arguments( arguments ) )
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