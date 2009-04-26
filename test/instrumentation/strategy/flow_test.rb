require File.join( File.dirname( __FILE__ ), '..', '..', 'helper' )

class FlowStrategyTest < Test::Unit::TestCase
  
  def setup
    @probe = Mri::Instrumentation::Test.probe
    @probes = Mri::Instrumentation.probes( Mri::Instrumentation::Test::PROBES )
    @probe_collection = Mri::Instrumentation::ProbeCollection.new( @probes )    
    @strategy = Mri::Instrumentation::Strategy::Flow.new( @probe, @probe_collection )
  end
  
  test "should be able to yield a header" do
    assert_equal " #!/usr/sbin/dtrace -ZFs \n             #pragma D option quiet\n\n             #pragma D option dynvarsize=64m\n\n              #pragma D option switchrate=5\n\n                   self int depth;\n \n ", @strategy.header
  end  
  
  test "should be able to yield a setup function" do
    assert_equal " dtrace:::BEGIN\n               \n               {\n                  printf(\"%14s %20s %19s\\n\", \"Memory Error/s\", \"New Object Created/s\", \"Memory allocation/s\");\n \n                }\n ", @strategy.setup
  end
  
  test "should be able to yield a function entry definition" do
    assert_equal " pid$target::ruby_xrealloc:entry\n               \n               {\n                  printf(\"%3d %-16d %-22s %*s->\\n\", cpu, timestamp / 1000, \nprobefunc, self->depth * 2, \"\" );\n \n                }\n ", @strategy.entry
  end

  test "should be able to yield a function return definition" do
    assert_equal " pid$target::ruby_xrealloc:return\n               \n               {\n                  printf(\"%3d %-16d %-22s %*s<-\\n\", cpu, timestamp / 1000, \n        probefunc, self->depth * 2, \"\" );\n \n                }\n ", @strategy.return
  end
  
end