module Mri
  module Instrumentation
    class Runner
      
      attr_accessor :probes, 
                    :pid,
                    :run,
                    :strategy
      
      def initialize( &block )
        instance_eval( &block )
      end
      
      def run!
      end        
      
    end
  end
end

=begin
  Mri::Instrumentation::Runner.new do 
    probes = :gc
    run = 'ruby -vv'
    strategy = :calltime
  end  
=end  