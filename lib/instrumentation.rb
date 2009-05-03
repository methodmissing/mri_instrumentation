$:.unshift( File.dirname(__FILE__), '..' )

require 'yaml'
require 'tempfile'
require 'optparse'

module Mri
  module Instrumentation
    
    MRI_VERSION = RUBY_VERSION.gsub('.','')[0..1]
    
    DIRECTORY = File.expand_path( File.join( File.dirname( __FILE__ ), '..' ) )
    
    PROBES = File.join( DIRECTORY, 'probes', MRI_VERSION ).freeze

    CONFIG = File.join( DIRECTORY, 'config', MRI_VERSION ).freeze

    EXTENSIONS = File.join( DIRECTORY, 'lib', 'mri', 'instrumentation', 'extensions' ).freeze

    autoload :Definition, 'mri/instrumentation/definition'        
    autoload :Probe, 'mri/instrumentation/probe'
    autoload :Argument, 'mri/instrumentation/argument'
    autoload :ProbeCollection, 'mri/instrumentation/probe_collection'
    autoload :Parser, 'mri/instrumentation/parser'
    
    module Strategy

      autoload :Builder, 'mri/instrumentation/strategy/builder'            
      autoload :Base, 'mri/instrumentation/strategy/base'      
      autoload :Calltime, 'mri/instrumentation/strategy/calltime'      
      autoload :Interval, 'mri/instrumentation/strategy/interval'
      autoload :Flow, 'mri/instrumentation/strategy/flow'
      autoload :Calls, 'mri/instrumentation/strategy/calls'
      autoload :Speculate, 'mri/instrumentation/strategy/speculate'
      autoload :Peek, 'mri/instrumentation/strategy/peek'
      autoload :Stack, 'mri/instrumentation/strategy/stack'
      
    end
    
    module Runner
      
      autoload :Base, 'mri/instrumentation/runner/base'
      autoload :Inline, 'mri/instrumentation/runner/inline'
      autoload :Command, 'mri/instrumentation/runner/command'      
      
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