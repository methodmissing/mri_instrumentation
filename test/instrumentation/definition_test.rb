require File.join( File.dirname( __FILE__ ), '..', 'helper' )

class DefinitionTest < Test::Unit::TestCase
  
  def setup
    @definition = Mri::Instrumentation::Definition.new( File.join( Mri::Instrumentation::Test::PROBES, 'gc.yml') )
  end
  
  test "should be able to read and parse it's definition" do
    assert_kind_of Array, @definition.read
  end
  
  test "should be able to infer it's group" do
    assert_equal :gc, @definition.group
  end
  
  test "should be able to setup it's probes" do
    assert_equal 3, @definition.probes.size
    assert_equal ["rb_memerror", "ruby_xmalloc", "rb_newobj"], @definition.probes.map{|p| p.name }
  end
  
end  