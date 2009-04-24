require File.join( File.dirname( __FILE__ ), '..', '..', 'helper' )

class CallsStrategyTest < Test::Unit::TestCase
  
  def setup
    @probe = Mri::Instrumentation::Test.probe
    @probes = Mri::Instrumentation.probes( Mri::Instrumentation::Test::PROBES )
    @probe_collection = Mri::Instrumentation::ProbeCollection.new( @probes )    
    @strategy = Mri::Instrumentation::Strategy::Calls.new( @probe, @probe_collection )
  end
  
  test "should be able to yield a header" do
    assert_equal " #!/usr/sbin/dtrace -Zs \n             #pragma D option quiet\n\n             #pragma D option dynvarsize=64m\n\n             \n ", @strategy.header
  end  
  
  test "should be able to yield a setup function" do
    assert_equal " dtrace:::BEGIN\n              { \n                 printf(\"Tracing... Hit Ctrl-C to end.\\n\");\n \n              }\n ", @strategy.setup
  end
  
  test "should be able to yield a function definition" do
    assert_equal " pid$target*:::ruby_xrealloc\n             {\n                this->type = probefunc;\nthis->arg0 = arg0;\nthis->arg1 = stringof( arg1 );\n                   @calls[this->type, this->arg0, this->arg1] = count(); \n              }\n ", @strategy.function
  end

  test "should be able to yield a report" do
    assert_equal " dtrace:::END\n              {\n                 printf(\" %-24s %-24s %20s\\n\", \"Probe\", \"arg0\", \"CALLS\");\n     \t   printa(\" %-24s %-24s %@20d\\n\", @calls); \n               }\n ", @strategy.report
  end
  
end