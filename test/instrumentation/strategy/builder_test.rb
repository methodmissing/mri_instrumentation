require File.join( File.dirname( __FILE__ ), '..', '..', 'helper' )

class StrategyBuilderTest < Test::Unit::TestCase
  
  def setup
    @strategy = Mri::Instrumentation::Strategy::Calltime
    @probes = Mri::Instrumentation.probes( Mri::Instrumentation::Test::PROBES )
    @builder = Mri::Instrumentation::Strategy::Builder.new( @strategy, @probes)
  end
  
  test "should be able to build a D stream" do
    assert_equal '', @builder.to_s
  end
  
end  