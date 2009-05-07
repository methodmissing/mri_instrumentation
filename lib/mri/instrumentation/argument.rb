module Mri
  module Instrumentation
    class Argument < Struct.new(:type, :description, :order)
      
      class TypeNotDefined < StandardError
      end
      
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
      
      TYPES = { 'VALUE' => ['copyinstr(%s)', '%s'],
                'VALUE *' => ['(string)%s', '%s'],
                'const VALUE *' => ['(string)%s', '%s'],
                'long int' => ['(string)%s', '%s'],
                'void' => ['%s', '%s'],
                'struct re_pattern_buffer *' => ['(string)%s', '%s'],
                'struct re_registers *' => ['(string)%s', '%s'],
                'int' => ['(string)%s', '%s'],
                'unsigned char *' => ['copyinstr(%s)', '%s'],
                'struct inspect_arg *' => ['copyinstr(%s)', '%s'],
                'VALUE (*)()' => ['copyinstr(%s)', '%s'],
                'struct ary_sort_data *' => ['copyinstr(%s)', '%s'],
                'VALUE (*)(VALUE, long int)' => ['(string)%s', '%s'],
                'void *' => ['%s', '%s'],
                'const double' => ['(string)%s', '%s'],
                'char' => ['copyinstr(%s)', '%s'],
                'unsigned int' => ['(string)%s', '%s'],
                'long int *' => ['(string)%s', '%s'],
                'struct st_hash_type *' => ['(string)%s', '%s'],
                'st_table' => ['(string)%s', '%s'],
                'st_table *' => ['(string)%s', '%s'],
                'st_data_t' => ['(string)%s', '%s'],
                'st_data_t *' => ['(string)%s', '%s'],
                'int (*)()' => ['(string)%s', '%s'],
                'const char *' => ['copyinstr(%s)', '%s'],
                'char **' => ['copyinstr(%s)', '%s'],
                'unsigned long int' => ['(string)%s', '%s'],
                'char *' => ['copyinstr(%s)', '%s'],
                'const unsigned char *' => ['copyinstr(%s)', '%s'],
                'unsigned long long int' => ['(string)%s', '%s'],
                'long long int' => ['(string)%s', '%s'],
                'double' => ['(string)%s', '%s'],
                'double *' => ['(string)%s', '%s'],
                'const char **' => ['copyinstr(%s)', '%s'],
                'struct dir_data *' => ['(string)%s', '%s'],
                'struct chdir_data *' => ['(string)%s', '%s'],
                'struct stat *' => ['(string)%s', '%s'],
                'DIR *' => ['(string)%s', '%s'],
                'struct glob_pattern *' => ['(string)%s', '%s'],
                'enum answer' => ['(string)%s', '%s'],
                'ruby_glob_func *' => ['(string)%s', '%s'],
                'void (*)(const char *, VALUE)' => ['(string)%s', '%s'],              
                'gid_t' => ['(string)%s', '%s'],
                'OpenFile *' => ['(string)%s', '%s'],
                'FILE *' => ['(string)%s', '%s'],
                'ID' => ['(string)%s', '%s'],
                'struct foreach_arg *' => ['%s', '%s'],
                'struct kwtable *' => ['%s', '%s'],
                :probe => ['%s', '%s']
              }  

      # Hash representation
      # 
      def to_hash
        { self.type => self.description }
      end
      
      # YAML representation
      #
      def to_yaml( opts = {} )
        to_hash.to_yaml
      end      
      
      # Type lookup accessor
      #
      def lookup
        TYPES[self.type] || raise( TypeNotDefined, "type not defined #{self.type.inspect}" )
      end
      
      # Format helper for D's printf
      #
      def to_format
        @format ||= lookup.last  
      end      

      # Massage into a format D can easily work with.
      # Standardized on everything being a string, for the time being.
      #
      def massage
        begin
          @massage ||= lookup.first % to_var( '_copy' )
        rescue => exception 
          raise( exception, self.inspect )
        end  
      end      
      
      # String representation as description
      #
      def to_s
        self.description
      end
      
      # Function variable
      #
      def to_var( suffix = '' )
        @to_var ||= {}
        @to_var[suffix] ||= probe? ? "self->type#{suffix}" : "self->#{to_arg}#{suffix}"
      end
      
      # Function variable assignment
      #
      def to_assignment
        @to_assignment ||= default_assignment #init_assignment
      end
      
      # Copy argument to a thread local ( pointers )
      #
      def to_copy
        @to_copy ||= "#{to_var( '_copy' )} = #{to_arg};"
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
      
      private
      
        def default_assignment
          "#{to_var} = #{massage};"
        end
      
    end
  end
end