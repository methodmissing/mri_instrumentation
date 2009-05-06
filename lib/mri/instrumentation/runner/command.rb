module Mri
  module Instrumentation
    module Runner
      class Command    
        
        attr_reader :configuration
        
        def initialize( arguments )
          @configuration = { :pid => 0,
                             :command => '',
                             :probes => '',
                             :strategy => :calltime }
          configure!( arguments )          
        end          
        
        # Setup a base runner and configure with the given command line options
        #
        def run!
          runner = Mri::Instrumentation::Runner::Base.new( true )
          runner.pid @configuration[:pid] if pid?
          runner.command @configuration[:command]
          runner.strategy @configuration[:strategy]
          runner.probes *@configuration[:probes]
          runner.run!
        end
        
        private
          
          # Should we attach to a PID
          #
          def pid?
            @configuration[:pid].to_i != 0
          end
        
          # Configure with the given arguments
          #
          def configure!( arguments )
            arguments.options do |o|
              o.set_summary_indent('  ')
              o.banner =    "Usage: #{o.program_name} [OPTIONS] probe1 probe2 probe3"
              o.define_head "MRI instrumentation with the dtrace pid provider"
              o.separator   ""
              o.on("-p", "-pid=[val]", Integer,
                     "The process identifier (PID) to attach to",
                     "Default: #{@configuration[:pid].to_s}") do |pid|
                       @configuration[:pid] = pid.to_s 
                     end
              o.on("-c", "-cmd=[val]", String,
                     "The command to run",
                     "Default: #{@configuration[:command].to_s}") do |cmd|
                       @configuration[:command] = "ruby #{cmd.to_s}" 
                     end
              o.on("-s", "-strategy=[val]", String,
                     "The desired profiling strategy",
                     "Default: #{@configuration[:strategy].to_s}") do |strategy|
                       @configuration[:strategy] = strategy.to_s 
                     end     
              o.separator ""       
              o.on_tail("-h", "--help", "Show this help message.") { puts o; exit }                                            
              o.parse!           
            end   
            @configuration[:probes] = arguments
          end
        
      end
    end
  end
end