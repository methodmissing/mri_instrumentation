module Mri
  module Instrumentation
    class Probe < Struct.new( :group, :name, :arguments )
      
      # String representation as name
      #
      def to_s
        self.name
      end
      
      # Argument size is arguments + 1, to accomodate the probe type
      #
      def argument_size
        @argument_size ||= self.arguments.size + 1
      end
      
      # Header for reporting
      #
      def report_header
        @header ||= ['"Probe"'].concat( self.arguments.map{|a| "\"#{a.to_s}\"" } ).join( ", " )
      end

      # Sprintf formatting for the header
      #
      def header_format
        @header_format ||= ( format << '%8s' ).join(' ')
      end
      
      # Sprintf formatting for the report
      #
      def report_format
        @report_format ||= ( format << '%@8d' ).join(' ')
      end
      
      # Entry declaration
      #
      def function_entry
        @function_entry ||= with_pid( 'entry' )
      end
      
      # Retrun declaration
      #
      def function_return
        @function_return ||= with_pid( 'return' )
      end
      
      # Yields a list of arguments for associative D arrays
      #
      def arguments_list
        "this->type, #{iterate_arguments( :to_var, ', ' )}"
      end
      
      # Assign massaged values to the arguments
      #
      def assign_arguments
        iterate_arguments( :to_assignment )
      end      
      
      private
        
        # Pid probe formatting
        #
        def with_pid( scope )
          "pid$target::#{self.name}:#{scope}"
        end
      
        # Format as all strings.
        #
        def format
          ['%-10s'] * argument_size
        end
        
        # Iterate and join arguments
        #
        def iterate_arguments( method, join_with = "\n" )
          self.arguments.map do |arg|
            arg.send(method)
          end.join( join_with )
        end  
      
    end   
  end
end