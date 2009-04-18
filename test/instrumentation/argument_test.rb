require File.join( File.dirname( __FILE__ ), '..', 'helper' )

class ArgumentTest < Test::Unit::TestCase
  
  def setup
    @argument = Mri::Instrumentation::Argument.new( :char, 'Filename', 0  )
  end
  
  test "should have a string representation" do
    assert_equal 'Filename', @argument.to_s 
  end
  
  test "should have a format representation" do
    assert_equal '%s', @argument.to_format
  end
  
  test "should have a variable representation" do
    assert_equal 'this->arg0', @argument.to_var
  end
  
  test "should be able to massage it's input value" do
    assert_equal 'copyinstr( arg0 )', @argument.massage
  end
  
  test "should have an assignment representation" do
    assert_equal 'this->arg0 = copyinstr( arg0 );', @argument.to_assignment
  end
  
end

class PointerArgumentTest < Test::Unit::TestCase
  
  def setup
    @argument = Mri::Instrumentation::Argument.new( :pointer, 'Address', 1  )
  end

  test "should have a format representation" do
    assert_equal '%#p', @argument.to_format
  end
  
  test "should be able to massage it's input value" do
    assert_equal 'arg1', @argument.massage
  end  
  
end  

class IntegerArgumentTest < Test::Unit::TestCase
  
  def setup
    @argument = Mri::Instrumentation::Argument.new( :int, 'Allocation Size', 2  )
  end
  
  test "should have a format representation" do
    assert_equal '%s', @argument.to_format
  end  

  test "should be able to massage it's input value" do
    assert_equal 'stringof( arg2 )', @argument.massage
  end
  
end