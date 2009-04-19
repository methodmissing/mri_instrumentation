module Mri
  module Instrumentation
    module Test
      
      unless const_defined?(:PATH)
        PATH = File.dirname( __FILE__ ).freeze 
      
        LIB = File.join( PATH, '..', 'lib', 'instrumentation' ).freeze
       
        FIXTURES = File.join( PATH, 'fixtures' ).freeze
        
        PROBES = File.join( FIXTURES, 'probes' ).freeze        
      end
      
      def self.setup
        require 'test/unit'
        require LIB
        ::Test::Unit::TestCase.send(:extend, Declarative)
      end
      
      def self.arguments
        [ Mri::Instrumentation::Argument.new( :pointer, 'Address', 0 ),
          Mri::Instrumentation::Argument.new( :int, 'Allocation Size', 1 ) ]
      end
      
      def self.probe( args = self.arguments )
        Mri::Instrumentation::Probe.new( :gc, 'ruby_xrealloc', args )
      end
      
      # thx ActiveSupport
      module Declarative
        
        def test(name, &block)
          test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
          defined = instance_method(test_name) rescue false
          raise "#{test_name} is already defined in #{self}" if defined
          if block_given?
            define_method(test_name, &block)
          else
            define_method(test_name) do
              flunk "No implementation provided for #{name}"
            end
          end
        end
        
      end
      
    end
  end
end

Mri::Instrumentation::Test.setup