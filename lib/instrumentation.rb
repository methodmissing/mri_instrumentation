$:.unshift( File.dirname(__FILE__), '..' )

require 'yaml'
require 'tempfile'

module Mri
  module Instrumentation
    
    MRI_VERSION = RUBY_VERSION.gsub('.','')[0..1]
    
    PROBES = File.join( File.dirname( __FILE__ ), '..', 'probes', MRI_VERSION ).freeze

    autoload :Definition, 'mri/instrumentation/definition'        
    autoload :Probe, 'mri/instrumentation/probe'
    autoload :Argument, 'mri/instrumentation/argument'
    autoload :ProbeCollection, 'mri/instrumentation/probe_collection'
    
    module Strategy

      autoload :Builder, 'mri/instrumentation/strategy/builder'            
      autoload :Base, 'mri/instrumentation/strategy/base'      
      autoload :Calltime, 'mri/instrumentation/strategy/calltime'      
      
    end
    
    module Runner
      
      autoload :Base, 'mri/instrumentation/runner/base'
      
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
      @probes ||= {}
      @probes[path] ||= definitions( path ).map{|p| p.probes }.flatten
    end  
    
    # Infer all probe groups from a given path
    #
    def self.groups( path = PROBES )
      @groups ||= {}
      @groups[path] ||= definitions( path ).map{|p| p.group }
    end  
    
  end  
end