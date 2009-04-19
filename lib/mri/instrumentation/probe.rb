module Mri
  module Instrumentation
    class Probe < Struct.new( :group, :name, :arguments )
      
      # String representation as name
      #
      def to_s
        self.name
      end
      
      # Argument size
      #
      def argument_size
        @argument_size ||= self.arguments.size
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
        iterate_arguments( :to_var, ', ' )
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