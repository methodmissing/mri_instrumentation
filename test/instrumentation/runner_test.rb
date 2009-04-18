require File.join( File.dirname( __FILE__ ), '..', 'helper' )

class RunnerTest < Test::Unit::TestCase
  
  def setup
    @probe = Mri::Instrumentation::Test.probe
    @runner = Mri::Instrumentation::Runner.new
  end
  
  test "should be able to have a process identifier set" do
    @runner.pid 1234
    assert_equal :pid, @runner.run_with 
  end
  
  test "should be able to have a command set" do
    @runner.command 'date'
    assert_equal :command, @runner.run_with 
  end  
  
  test "should default to a calltime strategy" do
    assert_equal :calltime, @runner.strategy
  end
  
end  