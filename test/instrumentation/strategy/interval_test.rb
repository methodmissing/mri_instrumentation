require File.join( File.dirname( __FILE__ ), '..', '..', 'helper' )

class IntervalStrategyTest < Test::Unit::TestCase
  
  def setup
    @probe = Mri::Instrumentation::Test.probe
    @probes = Mri::Instrumentation.probes( Mri::Instrumentation::Test::PROBES )
    @probe_collection = Mri::Instrumentation::ProbeCollection.new( @probes )    
    @strategy = Mri::Instrumentation::Strategy::Interval.new( @probe, @probe_collection )
  end
  
  test "should be able to yield a header" do
    assert_equal " #!/usr/sbin/dtrace -ZFs \n             #pragma D option quiet\n\n             #pragma D option dynvarsize=64m\n\n              inline int SCREEN = 21;\n \n ", @strategy.header
  end  
  
  test "should be able to yield a setup function" do
    assert_equal " dtrace:::BEGIN\n               \n               {\n                  rb_memerror = 0;\nrb_newobj = 0;\nruby_xmalloc = 0;\n                   lines = SCREEN + 1;  \n                }\n ", @strategy.setup
  end
  
  test "should be able to yield a function entry definition" do
    assert_equal " pid$target::ruby_xrealloc:entry \n             {\n               ruby_xrealloc++;\n              }\n ", @strategy.entry
  end
  
  test "should be able to yield a reporting function" do
    assert_equal  " profile:::tick-1sec\n              {\n              \tprintf(\"%20Y %6d %6d %6d\\n\", walltimestamp, rb_memerror, rb_newobj, ruby_xmalloc);\n\n              \trb_memerror = 0;\nrb_newobj = 0;\nruby_xmalloc = 0;\n              }\n ", @strategy.report
  end  
  
end