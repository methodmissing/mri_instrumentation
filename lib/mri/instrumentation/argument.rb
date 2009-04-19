module Mri
  module Instrumentation
    class Argument < Struct.new(:type, :description, :order)
      
      class << self
        
        # Yields the default probe argument
        #
        def probe
          @@probe ||= new( :probe, 'Probe', -1 )
        end
        
      end
      
      # Represents a probe argument.Initial support for pointers, strings 
      # and integers.
      #
      
      TYPES = { :char => ['copyinstr( %s )', '%s'],
                :pointer => ['%s', '%#p'],
                :int => ['stringof( %s )', '%s'],
                :probe => ['%s', '%s'] }
      
      # Format helper for D's printf
      #
      def to_format
        @format ||= TYPES[self.type.to_sym].last  
      end      

      # Massage into a format D can easily work with.
      # Standardized on everything being a string, for the time being.
      #
      def massage
        @massage ||= TYPES[self.type.to_sym].first % to_arg  
      end      
      
      # String representation as description
      #
      def to_s
        self.description
      end
      
      # Function variable
      #
      def to_var
        @to_var ||= probe? ? "this->type" : "this->#{to_arg}"
      end
      
      # Function variable assignment
      #
      def to_assignment
        @to_assignment ||= "#{to_var} = #{massage};"
      end
      
      # Argument representation.
      #
      def to_arg
        @arg ||= probe? ? 'probefunc' : "arg#{self.order.to_s}"
      end
      
      # Are we the first ( probe type ) argument ?
      #
      def probe?
        self.order == -1
      end
      
    end
  end
end