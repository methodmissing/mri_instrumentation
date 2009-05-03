require File.join( File.dirname( __FILE__ ), '..', 'helper' )

class ArgumentTest < Test::Unit::TestCase
  
  def setup
    @argument = Mri::Instrumentation::Argument.new( 'char *', 'Filename', 0  )
  end
  
  test "should have a hash representation" do
    assert_equal( { "char *" => "Filename" }, @argument.to_hash )
  end
  
  test "should have a yaml representation" do
    assert_equal "--- \nchar *: Filename\n", @argument.to_yaml
  end
  
  test "should be able to lookup types" do
    assert_equal ['%s', '%s'], @argument.lookup
    assert_raises Mri::Instrumentation::Argument::TypeNotDefined do
      @argument.type = 'undefined'
      @argument.lookup
    end    
  end
  
  test "should have a string representation" do
    assert_equal 'Filename', @argument.to_s 
  end
  
  test "should have a format representation" do
    assert_equal '%s', @argument.to_format
  end
  
  test "should have a variable representation" do
    assert_equal 'self->arg0', @argument.to_var
  end
  
  test "should be able to massage it's input value" do
    assert_equal 'self->arg0_copy', @argument.massage
  end
  
  test "should have an assignment representation" do
    assert_equal "self->arg0 = self->arg0_copy;", @argument.to_assignment
  end
  
  test "should have a copy representation" do
    assert_equal 'self->arg0_copy = arg0;', @argument.to_copy
  end
  
end