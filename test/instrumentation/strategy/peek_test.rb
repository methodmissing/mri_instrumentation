require File.join( File.dirname( __FILE__ ), '..', '..', 'helper' )

class PeekTest < Test::Unit::TestCase
  
  def setup
    @probe = Mri::Instrumentation::Test.probe
    @probes = Mri::Instrumentation.probes( Mri::Instrumentation::Test::PROBES )
    @probe_collection = Mri::Instrumentation::ProbeCollection.new( @probes )    
    @strategy = Mri::Instrumentation::Strategy::Peek.new( @probe, @probe_collection )
  end
  
  test "should be able to yield a header" do
    assert_equal " #!/usr/sbin/dtrace -ZFs \n             #pragma D option quiet\n\n             #pragma D option dynvarsize=64m\n\n              #pragma D option flowindent \n ", @strategy.header
  end  
  
  test "should be able to yield a setup function" do
    assert_equal " dtrace:::BEGIN\n               \n               {\n                 \n                }\n ", @strategy.setup
  end
  
  test "should be able to yield a guarded function entry definition" do
    assert_equal " pid$target::ruby_xrealloc:entry\n               /guard++ == 0/\n               {\n                  self->peek = 1;\n                        this->type = probefunc;\nthis->arg0 = arg0;\nthis->arg1 = stringof( arg1 );\n                        printf( \"%13s\", this->type, this->arg0, this->arg1 ); \n                }\n ", @strategy.guarded_entry
  end

  test "should be able to yield a function return definition" do
    assert_equal " pid$target::ruby_xrealloc:return\n               /self->peek/\n               {\n                  self->peek = 0;\n                   exit(0); \n                }\n ", @strategy.return
  end

  test "should be able to yield a peek function definition" do
    assert_equal " pid$target:::\n               /self->peek/\n               {\n                 \n                }\n ", @strategy.peek
  end
  
end