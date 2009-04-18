module Mri
  module Instrumentation
    class Runner
      
      attr_reader :probes,
                  :run_with, 
                  :pid,
                  :command,
                  :strategy
      
      def initialize( &block )
        instance_eval( &block ) if block_given?
      end
      
      def probes( *probes )
        @probes = probes
      end
      
      def pid( pid )
        @run_with = :pid
        @pid = pid
      end  
      
      def command( command )
        @run_with = :command
        @command = command
      end
      
      def run!
        generate do
          run_with_command? ? run_with_command : attach_to_pid
        end
      end        
      
      def strategy
        @strategy || :calltime
      end
      
      private
  
        def generate
          Tempfile.open do |file|
            file << 'probes'
            %x[ sudo dtrace -s #{file.path} #{yield}]
          end
        end
       
        def run_with_command?
          @run_with == :command
        end  
      
        def attach_to_pid
          "-p #{@pid.to_s}"
        end
        
        def run_with_command
          "-c \"#{@command}\""
        end
        
        def strategy_instance
          @strategy_instance ||= nil
        end
        
    end
  end
end

=begin
  Mri::Instrumentation::Runner.new do 
    probes :gc
    run 'ruby -vv'
    strategy :calltime
  end  
=end  