require File.join( File.dirname( __FILE__ ), '..', 'helper' )

class DefinitionTest < Test::Unit::TestCase
  
  def setup
    @definition = Mri::Instrumentation::Definition.new( File.join( Mri::Instrumentation::Test::PROBES, 'gc.yml') )
  end
  
  test "should be able to read and parse it's definition" do
    assert_kind_of Hash, @definition.read
  end
  
  test "should be able to infer it's group" do
    assert_equal :gc, @definition.group
  end
  
  test "should be able to setup it's probes" do
    assert_equal 2, @definition.probes.size
    assert_equal %w(rb_memerror ruby_xmalloc), @definition.probes.map{|p| p.name }
  end
  
end  