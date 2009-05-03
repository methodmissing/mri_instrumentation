=begin
require File.join( File.dirname( __FILE__ ), '..', '..', 'helper' )

class SpeculateTest < Test::Unit::TestCase
  
  def setup
    @probe = Mri::Instrumentation::Test.probe
    @probes = Mri::Instrumentation.probes( Mri::Instrumentation::Test::PROBES )
    @probe_collection = Mri::Instrumentation::ProbeCollection.new( @probes )    
    @strategy = Mri::Instrumentation::Strategy::Speculate.new( @probe, @probe_collection )
  end
  
  test "should be able to yield a header" do
    assert_equal " #!/usr/sbin/dtrace -ZFs \n             #pragma D option quiet\n\n             #pragma D option dynvarsize=64m\n\n              #pragma D option flowindent \n ", @strategy.header
  end  
  
  test "should be able to yield a setup function" do
    assert_equal " dtrace:::BEGIN\n               \n               {\n                 \n                }\n ", @strategy.setup
  end
  
  test "should be able to yield a function entry definition" do
    assert_equal " pid$target::ruby_xrealloc:entry\n               \n               {\n                  self->spec = speculation(); \n                   speculate(self->spec);\n                   printf(\"%11s %9s %12s\\n\", \"rb_memerror/s\", \"rb_newobj/s\", \"ruby_xmalloc/s\"); \n                }\n ", @strategy.entry
  end

  test "should be able to yield a function return success definition" do
    assert_equal " pid$target::ruby_xrealloc:return\n               /self->spec && errno == 0/\n               {\n                  commit(self->spec);\n                        self->spec = 0; \n                }\n ", @strategy.return_success
  end

  test "should be able to yield a function return failure definition" do
    assert_equal " pid$target::ruby_xrealloc:return\n               /self->spec && errno != 0/\n               {\n                  discard(self->spec); \n                        self->spec = 0; \n                }\n ", @strategy.return_failure
  end
  
end
=end