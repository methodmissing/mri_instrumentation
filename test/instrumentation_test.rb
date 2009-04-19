require File.join( File.dirname( __FILE__ ), 'helper' )

class InstrumentationTest < Test::Unit::TestCase
  
  test "should be able to instantiate probe definitions for a given path" do
    assert_equal 1, Mri::Instrumentation.definitions( Mri::Instrumentation::Test::PROBES ).size
  end
  
  test "should be able to infer groups from a given probe definition path" do
    assert_equal [:gc], Mri::Instrumentation.groups( Mri::Instrumentation::Test::PROBES )
  end  
  
end  