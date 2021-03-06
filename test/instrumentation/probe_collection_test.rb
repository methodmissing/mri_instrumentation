require File.join( File.dirname( __FILE__ ), '..', 'helper' )

class ProbeCollectionTest < Test::Unit::TestCase
  
  def setup
    @probes = Mri::Instrumentation.probes( Mri::Instrumentation::Test::PROBES )
    @probe_collection = Mri::Instrumentation::ProbeCollection.new( @probes )
  end
  
  test "should be able to calculate it's maximum argument size" do
    assert_equal 2, @probe_collection.arguments_size
  end

  test "should be able to calculate it's maximum length" do
    assert_equal 12, @probe_collection.length
  end
  
  test "should be able to yield a report header" do
    assert_equal "\"Probe\", \"arg0\"", @probe_collection.report_header
  end
  
  test "should be able to yield a header format" do
    assert_equal "%-24s %-24s %20s", @probe_collection.header_format
  end
  
  test "should be able to yield a report format" do
    assert_equal "%-24s %-24s %@20d", @probe_collection.report_format
  end  
  
  test "should be able to determine if all probes has a return type" do
    assert @probe_collection.return?
  end
  
  test "should have a format string representation" do
    assert_equal "%11s %12s %9s", @probe_collection.format_string
    assert_equal "%13s %14s %11s", @probe_collection.format_string( '/s' )
  end

  test "should have a string representation" do
    assert_equal "rb_memerror ruby_xmalloc rb_newobj", @probe_collection.to_s
    assert_equal "\"rb_memerror/s\" \"ruby_xmalloc/s\" \"rb_newobj/s\"", @probe_collection.to_s( '/s', ' ', "\"" )
  end

  test "should have a description representation" do
    assert_equal "rb_memerror ruby_xmalloc rb_newobj", @probe_collection.description
    assert_equal "\"rb_memerror/s\" \"ruby_xmalloc/s\" \"rb_newobj/s\"", @probe_collection.description( '/s', ' ', "\"" )
  end
  
  test "should have a result format representation" do
    assert_equal "%6d %6d %6d", @probe_collection.result_format
  end
  
end  