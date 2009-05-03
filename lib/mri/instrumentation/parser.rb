require 'rubygems'
require 'cast'

module Mri
  module Instrumentation
    class Parser < C::Parser
      
      INCLUDE_PATH = File.expand_path(File.join( CONFIG, 'include' ))      
      
      class << self
        
        def config( file )
          YAML.load( IO.read( File.join( CONFIG, file ) ) )
        end
      
        def include_path( path )
          File.join( INCLUDE_PATH, path )
        end

        def extensions!
          %w(function_def).each do |ext|
            require File.join( EXTENSIONS, 'parser', ext )
          end
        end
        
        def probes!( mri_source )
          FILES.each do |file|
            Mri::Instrumentation::Parser.new( File.join( mri_source, file ) ).probes!
          end  
        end
        
      end  
            
      INCLUDE_PATHS = [ INCLUDE_PATH,
                        include_path( 'sys' ),
                        include_path( 'net' ),
                        include_path( 'ruby' ) ]
      
      TYPES = config( 'types.yml' )
      
      MACROS = config( 'macros.yml' )

      FILES = config( 'files.yml' )

      IGNORES = config( 'ignores.yml' )
 
      attr_accessor :preprocessor,
                    :source_file,
                    :source_buffer, 
                    :tree
      
      def initialize( source_file )
        @source_file = source_file
        super()
        setup_preprocessor
        @source_buffer = []
        @source = ''
        configure
      end
      
      # Have we parsed the source file already?
      #
      def parsed?
        @source != ''
      end
      
      # Parse the source file to an AST tree
      #
      def parse( *args )
        with_safety do
          pos.filename = source_file
          @tree = super( read )
        end unless parsed?
      end  

      # Extract all function definitions of interest 
      #
      def probes
        parse
        @probes ||= setup_probes
      end
      
      # Persist function definitions to probes/<mri_version>/<group>.yml
      #
      def probes!
        File.open( result, 'w+' ) do |file|
          file << probes.to_yaml
        end
      end
      
      # The raw and preprocessed source file
      #
      def read
        @read ||= read_lines( preprocess )
      end      
      
      # Source filename to probe group
      #
      def group
        @group ||= source_file.split( '/' ).last.gsub(/\.c|\.y/, '')
      end
      
      # Output definition
      #
      def result
        @result ||= File.join( PROBES, "#{group}.yml" )
      end

      # Should we ignore the given function definition ?
      #
      def ignore?( function_def )
        IGNORES.include?( function_def.name.to_s )
      end  
      
      private
      
        # Convert all interesting functions to probe definitions
        #
        def setup_probes
          funcs = Mri::Instrumentation::ProbeCollection.new
          each_function do |func|
            funcs << func.to_probe( group ) unless ignore?( func )
          end         
          funcs   
        end
      
        # Yields each function definition node
        #
        def each_function
          tree.entities.each do |node|
            if node.is_a? C::FunctionDef
              yield node
            end
          end  
        end
      
        # Parse with safety
        #
        def with_safety
          begin
            yield
          rescue C::ParseError => exception
            puts exception.message
            puts exception.backtrace.join("\n")
            inspect_source
          end    
        end
        
        # Inspect the preprocessed source with Textmate
        #
        def inspect_source
          Tempfile.open( 'mri_parser' ) do |file|
            file << @source
            file.flush
            %x[mate #{file.path}]
            sleep 1 # Allow for potential startup
          end
        end
              
        # Preprocess with gcc -E
        #      
        def preprocess
          @preprocessor.preprocess_file( @source_file )
        end
        
        # Filter source lines
        #
        def read_lines( io )
          io.each do |line|
            unless line.match(/#|typedef unsigned long|typedef void|typedef struct rb_thread|typedef int|__attribute__|__inline/)
              @source_buffer << line
            end
          end
          @source = @source_buffer.join
        end
      
        # Configure this parser
        #
        def configure
          TYPES.each do |type|
            type_names << type
          end
          self.class.extensions!
        end
      
        # Setup the preprocessor
        #
        def setup_preprocessor
          @preprocessor = C::Preprocessor.new
          C::Preprocessor.command = "gcc -E"
          @preprocessor.include_path = INCLUDE_PATHS        
          @preprocessor.macros = MACROS
        end
      
    end
  end  
end