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
      
      TYPES = { 'VALUE' => ['%s', '(string)%d'],
                'VALUE *' => ['%s', '(string)%d'],
                'const VALUE *' => ['%s', '(string)%d'],
                'long int' => ['%s', '(string)%d'],
                'void' => ['%s', '%s'],
                'int' => ['%s', '(string)%d'],
                'struct inspect_arg *' => ['%s', '%s'],
                'VALUE (*)()' => ['%s', '%s'],
                'struct ary_sort_data *' => ['%s', '%s'],
                'VALUE (*)(VALUE, long int)' => ['%s', '%s'],
                'void *' => ['%s', '%s'],
                'struct st_hash_type *' => ['%s', '%s'],
                'st_table' => ['%s', '%s'],
                'st_table *' => ['%s', '%s'],
                'st_data_t' => ['%s', '%s'],
                'st_data_t *' => ['%s', '%s'],
                'int (*)()' => ['%s', '(string)%d'],
                'const char *' => ['%s', 'copyinstr(%s)'],
                'unsigned long int' => ['%s', '(string)%d'],
                'char *' => ['%s', '%s'],
                'const unsigned char *' => ['%s', '%s'],
                'unsigned long long int' => ['%s', '(string)%d'],
                'long long int' => ['%s', '(string)%d'],
                'double' => ['%s', '(string)%d'],
                'double *' => ['%s', '(string)%d'],
                'const char **' => ['%s', '%s'],
                'struct dir_data *' => ['%s', '%s'],
                'struct chdir_data *' => ['%s', '%s'],
                'struct stat *' => ['%s', '%s'],
                'DIR *' => ['%s', '%s'],
                'struct glob_pattern *' => ['%s', '%s'],
                'enum answer' => ['%s', '%s'],
                'ruby_glob_func *' => ['%s', '%s'],
                'void (*)(const char *, VALUE)' => ['%s', '%s'],              
                'gid_t' => ['%s', '%s'],
                'OpenFile *' => ['%s', '%s'],
                'FILE *' => ['%s', '%s'],
                'ID' => ['%s', 'stringof(%d)'],
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
        @massage ||= lookup.first % to_var( '_copy' )
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