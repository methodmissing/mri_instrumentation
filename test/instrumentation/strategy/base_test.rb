=begin
require File.join( File.dirname( __FILE__ ), '..', '..', 'helper' )

class BaseStrategyTest < Test::Unit::TestCase
  
  def setup
    @probe = Mri::Instrumentation::Test.probe
    @strategy = Mri::Instrumentation::Strategy::Base.new( @probe )
  end
  
  test "should delegate missing methods to the associated probe" do
    assert_equal 'pid$target::ruby_xrealloc:return', @strategy.function_return
  end  
  
  test "should be able to yield function definitions to build" do
    assert_equal [:entry, :return], @strategy.functions
  end
  
  test "should be able to yield a header" do
    assert_match /pragma/, @strategy.header
  end  
  
  test "should be able to yield a setup function" do
    assert_match /BEGIN/, @strategy.setup
    assert_match /test/, @strategy.setup( 'test')
  end
  
  test "should be able to yield a function entry definition" do
    assert_match /ruby_xrealloc:entry/, @strategy.entry
    assert_match /test/, @strategy.entry( 'test' )
  end
  
  test "should be able to yield a function return definition" do
    assert_match /ruby_xrealloc:return/, @strategy.return 
    assert_match /test/, @strategy.return( 'test' )
  end  

  test "should be able to yield a reporting function" do
    assert_match /END/, @strategy.report
    assert_match /test/, @strategy.report( 'test')
  end 
  
end  
=end