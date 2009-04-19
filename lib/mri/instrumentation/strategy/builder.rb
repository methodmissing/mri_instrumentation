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
            @buffer << @root.header
            @buffer << @root.setup
            build_each()
            @buffer << @root.report
          end
          
          # Build the entry and return function definitions for each probe
          #
          def build_each
            @probes.each do |probe|
              strategy_instance = strategy.new( probe )
              @buffer << strategy_instance.entry
              @buffer << strategy_instance.return
            end  
          end  
        
      end
    end
  end
end