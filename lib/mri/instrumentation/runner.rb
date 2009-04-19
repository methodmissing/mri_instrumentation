module Mri
  module Instrumentation
    class Runner
      
      attr_reader :run_with,
                  :result
      
      def initialize( &block )
        @probes = []
        instance_eval( &block ) if block_given?
      end
      
      # Instrument with the given probes
      #
      def probes( *probes )
        probes.empty? ? @probes : self.probes=( probes )
      end
      
      # Attach to a given PID
      #
      def pid( pid = nil )
        pid ? self.pid=( pid ) : @pid
      end
      
      # Run a given command
      #      
      def command( command = nil )
        command ? self.command=( command ) : @command
      end
      
      # The desired profiling strategy
      #
      def strategy( strategy = nil )
        if strategy  
          self.strategy=( strategy ) 
        else
          @strategy_instance ||= setup_strategy( @strategy || :calltime )
        end
      end      
      
      # Run this definition
      #
      def run!
        generate do
          run_command? ? run_command : attach_to_pid
        end
      end        
                  
      private
  
        # Probes setter
        #
        def probes=( probes )
          @probes = setup_probes( probes.map{|p| p.to_s } )
        end  
  
        # Pid setter
        #
        def pid=( pid )
          @run_with = :pid
          @pid = pid  
        end  
  
        # Command setter
        #
        def command=( command )
          @run_with = :command
          @command = command
        end  
  
        # Strategy setter
        #
        def strategy=( strategy )
          @strategy = strategy
        end  
  
        # Generates a dtrace script / stream
        #
        def generate
          Tempfile.open( 'mri_instrumentation' ) do |file|
            file << d_stream()
            file.flush
            cmd = "sudo dtrace -s #{file.path} #{yield}"
            @result = %x[#{cmd}]
          end
        end
       
        # Are we running a command ?
        #
        def run_command?
          @run_with == :command
        end  
      
        # Attach to the given PID
        #
        def attach_to_pid
          "-p #{@pid.to_s}"
        end
        
        # Run the given command
        #
        def run_command
          "-c '#{@command}'"
        end
        
        # Convert given probe signatures to probe instances
        #
        def setup_probes( probes )
          probes.map do |probe|
            probe_group?( probe ) ? probes_grouped( probe ) : probe_definition( probe )
          end.flatten  
        end
        
        # Yields a probe definition from a probe
        #
        def probe_definition( probe )
          Mri::Instrumentation.probes.detect{|p| p.name == probe }
        end  
        
        # Yields all probes that's a member of the given group signature
        #
        def probes_grouped( group )
          Mri::Instrumentation.probes.select{|p| p.group == group.to_sym }
        end  
        
        # Is the given probe signature a probe group signature ?
        #
        def probe_group?( probe )
          Mri::Instrumentation.groups.include?( probe.to_sym )
        end
        
        # Returns qualified 
        #
        def setup_strategy( strategy  )
          Object.module_eval("Mri::Instrumentation::Strategy::#{strategy_const( strategy )}", __FILE__, __LINE__)
        end
        
        # Constant representation of a given strategy signature
        #
        def strategy_const( strategy )
          strategy.to_s.gsub( /\/(.?)/ ) { "::#{$1.upcase}" }.gsub( /(?:^|_)(.)/ ) { $1.upcase }
        end  
        
        # Build the D stream
        #
        def d_stream
          Mri::Instrumentation::Strategy::Builder.new( self.strategy, self.probes ).to_s
        end
        
    end
  end
end

=begin
  Mri::Instrumentation::Runner.new do 
    probes :gc
    command 'ruby -v'
    strategy :calltime
  end  
=end  