module Mri
  module Instrumentation
    module Strategy
      class Builder
        
        attr_accessor :strategy,
                      :probes,
                      :buffer
                      
        def initialize( strategy, probes )
          @strategy = strategy
          @probes = Mri::Instrumentation::ProbeCollection.new( probes )
          @buffer = ''
          @root = @strategy.new( probes.first, @probes )
          build()
        end               
        
        # Script as string representation
        #
        def to_s
          @buffer
        end   
        
        private
        
          # Build the D script
          #
          def build
            build_each
            @buffer = @root.build do
              @buffer
            end
          end
          
          # Build the entry and return function definitions for each probe
          #
          def build_each( buf = '' )
            @probes.each do |probe|
              strategy_instance = strategy.new( probe, @probes )
              strategy_instance.functions.each do |func|
                @buffer << strategy_instance.send(func)
              end  
            end  
          end  
        
      end
    end
  end
end