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
      def arguments_list( pad = 0 )
        @arguments_list ||= {}
        @arguments_list[pad] ||= setup_arguments_list( pad )
      end
      
      # Assign massaged values to the arguments
      #
      def assign_arguments
        iterate_arguments( self.arguments, :to_assignment )
      end      
      
      private
        
        # Pid probe formatting
        #
        def with_pid( scope )
          "pid$target::#{self.name}:#{scope}"
        end
        
        # Setup and optionally pad the argument list
        #
        def setup_arguments_list( pad )
          pad_with = pad - argument_size
          args = self.arguments.dup.sort{|a,b| a.order <=> b.order }
          if pad_with > 0
            args.concat( ["\"\""] * pad_with )
          end
          iterate_arguments( args, :to_var, ', ' )
        end  
        
        # Iterate and join arguments
        #
        def iterate_arguments( args, method, join_with = "\n" )
          args.map do |arg|
            arg.respond_to?(method) ? arg.send(method) : arg
          end.join( join_with )
        end  
      
    end   
  end
end