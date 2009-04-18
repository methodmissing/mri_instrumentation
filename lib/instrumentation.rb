$:.unshift( File.dirname(__FILE__), '..' )

require 'yaml'

module Mri
  module Instrumentation
    
    MRI_VERSION = RUBY_VERSION.gsub('.','')[0..1]
    
    PROBES = File.join( File.dirname( __FILE__ ), '..', 'probes', MRI_VERSION ).freeze
    
    def self.groups
      @groups ||= Dir["#{PROBES}/*.yml"].map{|f| f.match( /([^\/|.]*).yml$/ )[1].to_sym }
    end
    
    autoload :Probe, 'mri/instrumentation/probe'
    autoload :Argument, 'mri/instrumentation/argument'
    autoload :Runner, 'mri/instrumentation/runner'
    
    module Strategy
      
      autoload :Base, 'mri/instrumentation/strategy/base'      
      autoload :Calltime, 'mri/instrumentation/strategy/calltime'      
      
    end
    
  end  
end

puts Mri::Instrumentation.groups.inspect