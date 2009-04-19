require File.join( File.dirname( __FILE__ ), '..', 'helper' )

class ProbeCollectionTest < Test::Unit::TestCase
  
  def setup
    @probes = Mri::Instrumentation.probes( Mri::Instrumentation::Test::PROBES )
    @probe_collection = Mri::Instrumentation::ProbeCollection.new( @probes )
  end
  
  test "should be able to calculate it's maximum argument size" do
    assert_equal 2, @probe_collection.argument_size
  end
  
  test "should be able to yield a report header" do
    assert_equal "\"Probe\", \"arg0\", \"arg1\"", @probe_collection.report_header
  end
  
  test "should be able to yield a header format" do
    assert_equal "%-10s %-10s %8s", @probe_collection.header_format
  end
  
  test "should be able to yield a report format" do
    assert_equal "%-10s %-10s %@8d", @probe_collection.report_format
  end  
  
end  