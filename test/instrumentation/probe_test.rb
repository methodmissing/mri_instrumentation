require File.join( File.dirname( __FILE__ ), '..', 'helper' )

class ProbeTest < Test::Unit::TestCase
  
  def setup
    @probe = Mri::Instrumentation::Test.probe
  end
  
  test "should have a string representation" do
    assert_equal 'ruby_xrealloc', @probe.to_s
  end
  
  test "should be able to calculate it's argument size" do
    assert_equal 3, @probe.argument_size
  end

  test "should be able to yield an entry function name" do
    assert_equal 'pid$target::ruby_xrealloc:entry', @probe.function_entry
  end

  test "should be able to yield a return function name" do
    assert_equal 'pid$target::ruby_xrealloc:return', @probe.function_return
  end
  
  test "should be able to yield an arguments list" do
    assert_equal 'this->type, this->arg0, this->arg1', @probe.arguments_list
    assert_equal "this->type, this->arg0, this->arg1, \"\", \"\"", @probe.arguments_list( 5 )
    assert_equal "this->type, this->arg0, this->arg1, \"\"", @probe.arguments_list( 4 )
  end
  
  test "should be able to assign it's arguments from within a function def" do
    assert_equal "this->type = probefunc;\nthis->arg0 = arg0;\nthis->arg1 = stringof( arg1 );", @probe.assign_arguments
  end
  
end  