module Mri
  module Instrumentation
    class Probe < Struct.new( :group, :name, :probe_description, :arguments, :return )
      
      # Format string representation of the probe name
      #
      def format_string( suffix = '', method = :to_s )
        "%#{send( method, suffix).size}s" 
      end
      
      # Probe description
      #
      def description( suffix = '' )
        desc = self.probe_description.nil? ? self.name : self.probe_description
        "#{desc}#{suffix}"
      end
            
      # String representation as name
      #
      def to_s( suffix = '' )
        "#{self.name}#{suffix}"
      end
      
      # True if no explicit return type
      # 
      def void?
        @void ||= self.return == 'void'
      end
      
      # Argument size
      #
      def argument_size
        @argument_size ||= self.arguments.size
      end
      
      # The length of the probe name
      #
      def length
        @length ||= self.name.size
      end      
      
      # Wildcard probe
      #
      def wildcard
        @wildcard ||= "pid$target:::"
      end  
      
      # Function declaration
      #
      def function
        @function ||= "pid$target*:::#{self.name}"
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
      def arguments_list( padding = 0 )
        @arguments_list ||= {}
        @arguments_list[padding] ||= setup_arguments_list( padding )
      end
      
      # Assign massaged values to the arguments
      #
      def assign_arguments
        iterate_arguments( self.arguments, :to_assignment )
      end      
      
      # The argument representing the probe type
      #
      def probe_argument
        self.arguments.detect{|a| a.probe? }
      end
      
      private
        
        # Pid probe formatting
        #
        def with_pid( scope )
          "pid$target::#{self.name}:#{scope}"
        end
        
        # Setup and optionally pad the argument list
        #
        def setup_arguments_list( padding )
          padding = padding - argument_size
          iterate_arguments( pad_arguments( padding ), :to_var, ', ' )
        end  
        
        # Pad the argument list
        #
        def pad_arguments( padding )
          args = self.arguments.dup.sort{|a,b| a.order <=> b.order }
          if padding > 0
            args.concat( ["\"\""] * padding )
          end
          args
        end
        
        # Iterate and join arguments
        #
        def iterate_arguments( args, method, join_with = "\n" )
          args.map do |arg|
            arg.respond_to?(method) ? arg.send(method) : "\"\""
          end.join( join_with )
        end  
      
    end   
  end
end