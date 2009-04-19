$:.unshift( File.dirname(__FILE__), '..' )

require 'yaml'

module Mri
  module Instrumentation
    
    MRI_VERSION = RUBY_VERSION.gsub('.','')[0..1]
    
    PROBES = File.join( File.dirname( __FILE__ ), '..', 'probes', MRI_VERSION ).freeze

    autoload :Definition, 'mri/instrumentation/definition'        
    autoload :Probe, 'mri/instrumentation/probe'
    autoload :Argument, 'mri/instrumentation/argument'
    autoload :Runner, 'mri/instrumentation/runner'
    
    module Strategy
      
      autoload :Base, 'mri/instrumentation/strategy/base'      
      autoload :Calltime, 'mri/instrumentation/strategy/calltime'      
      
    end
    
    # Setup all probe definitions from a given path
    #
    def self.definitions( path = PROBES )
      @definitions ||= {}
      @definitions[path] ||= Dir["#{path}/*.yml"].map{|p| Mri::Instrumentation::Definition.new( p ) }
    end
    
    # Infer all available probes
    #
    def self.probes( path = PROBES )
      @probes ||= definitions( path ).map{|p| p.probes }.flatten
    end  
    
    # Infer all probe groups from a given path
    #
    def self.groups( path = PROBES )
      @groups ||= definitions( path ).map{|p| p.group }
    end  
    
  end  
end