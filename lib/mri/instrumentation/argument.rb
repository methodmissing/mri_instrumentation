module Mri
  module Instrumentation
    class Argument < Struct.new(:type, :description, :order)
      
      # Represents a probe argument.Initial support for pointers, strings 
      # and integers.
      #
      
      TYPES = { :char => ['copyinstr( %s )', '%s'],
                :pointer => ['%s', '%#p'],
                :int => ['stringof( %s )', '%s'] }
      
      # Format helper for D's printf
      #
      def to_format
        @format ||= TYPES[self.type].last  
      end      

      # Massage into a format D can easily work with.
      # Standardized on everything being a string, for the time being.
      #
      def massage
        @massage ||= TYPES[self.type].first % to_arg  
      end      
      
      # String representation as description
      #
      def to_s
        self.description
      end
      
      # Function variable
      #
      def to_var
        @to_var ||= "this->#{to_arg}"
      end
      
      # Function variable assignment
      #
      def to_assignment
        @to_assignment ||= "#{to_var} = #{massage};"
      end
      
      # Argument representation.
      #
      def to_arg
        @arg ||= "arg#{self.order.to_s}"
      end
      
    end
  end
end