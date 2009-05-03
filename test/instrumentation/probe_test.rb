require File.join( File.dirname( __FILE__ ), '..', 'helper' )

class ProbeTest < Test::Unit::TestCase
  
  def setup
    @probe = Mri::Instrumentation::Test.probe
  end
  
  test "should have a hash representation" do
    assert_equal( { "ruby_xrealloc" => { 
                     "arguments" =>
                       [{:probe=>"Probe"}, {"char *"=>"Address"}, {"int"=>"Allocation Size"}],
                     "storage" => nil,
                     "desc" => "ruby_xrealloc",
                     "return" => "VALUE" } }, @probe.to_hash )
  end
  
  test "should have a yaml representation" do
    assert_equal "--- \nruby_xrealloc: \n  arguments: \n  - :probe: Probe\n  - char *: Address\n  - int: Allocation Size\n  storage: \n  desc: ruby_xrealloc\n  return: VALUE\n", @probe.to_yaml
  end
  
  test "should be able to yield a format string representation of itself" do
    assert_equal '%13s', @probe.format_string
    assert_equal '%15s', @probe.format_string( '/s' )
  end
  
  test "should have a description" do
    assert_equal 'Reallocation', @probe.description
  end
  
  test "should have a string representation" do
    assert_equal 'ruby_xrealloc', @probe.to_s
  end
  
  test "should be able to determine if it's static" do
    assert !@probe.static?
  end
  
  test "should be able to determine if it's external" do
    assert !@probe.extern?
  end
  
  test "should be able to determine if it has an entry" do
    assert @probe.entry?
  end
  
  test "should be able to determine if it has a return" do
    assert @probe.return?
  end
  
  test "should be able to calculate it's length" do
    assert_equal 13, @probe.length
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
  
  test "should be able to yield a function name" do
    assert_equal 'pid$target*:::ruby_xrealloc', @probe.function
  end
  
  test "should be able to yield a wildcard probe name" do
    assert_equal 'pid$target:::', @probe.wildcard
  end
  
  test "should be able to yield an arguments list" do
    assert_equal 'self->type, self->arg0, self->arg1', @probe.arguments_list
    assert_equal "self->type, self->arg0, self->arg1, \"\", \"\"", @probe.arguments_list( 5 )
    assert_equal "self->type, self->arg0, self->arg1, \"\"", @probe.arguments_list( 4 )
  end
  
  test "should be able to assign it's arguments from within a function def" do
    assert_equal "self->type = self->type_copy;\nself->arg0 = self->arg0_copy;\nself->arg1 = self->arg1_copy;", @probe.assign_arguments
  end
  
  test "should be able to find it's probe argument" do
    assert_equal "Probe", @probe.probe_argument.description
  end
  
end  