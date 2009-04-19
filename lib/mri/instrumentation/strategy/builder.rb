module Mri
  module Instrumentation
    module Strategy
      class Builder
        
        attr_accessor :strategy,
                      :probes,
                      :buffer
                      
        def initialize( strategy, probes )
          @strategy = strategy
          @probes = probes
          @buffer = ''
          @root = @strategy.new( probes.first )
          build()
        end               
        
        def to_s
          @buffer
        end   
        
        private
        
          def build
            @buffer << @root.header
            @buffer << @root.setup
            build_each()
            @buffer << @root.report
          end
          
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