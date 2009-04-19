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
    assert_equal Mri::Instrumentation::Strategy::Calltime, @runner.strategy
  end
  
  test "should be able to yield instrumentation probes from a given group signature" do
    @runner.probes :gc
    assert_equal 2, @runner.probes.size
  end

  test "should be able to yield instrumentation probes from a given group of probe signatures" do
    @runner.probes :rb_memerror
    assert_equal 1, @runner.probes.size
  end
   
  test "should be able to run it's strategy" do
    @runner.probes :gc
    @runner.command "ruby #{Mri::Instrumentation::Test::TARGET}"
    @runner.strategy :calltime  
    @runner.run!
  end 
   
end  