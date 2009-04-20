require File.join( File.dirname( __FILE__ ), '..', '..', 'helper' )

class CalltimeStrategyTest < Test::Unit::TestCase
  
  def setup
    @probe = Mri::Instrumentation::Test.probe
    @probes = Mri::Instrumentation.probes( Mri::Instrumentation::Test::PROBES )
    @probe_collection = Mri::Instrumentation::ProbeCollection.new( @probes )    
    @strategy = Mri::Instrumentation::Strategy::Calltime.new( @probe, @probe_collection )
  end
  
  test "should be able to yield a header" do
    assert_match /pragma/, @strategy.header
    assert_equal " #!/usr/sbin/dtrace -Zs \n\n             #pragma D option quiet\n ", @strategy.header
  end  
  
  test "should be able to yield a setup function" do
    assert_match /BEGIN/, @strategy.setup
    assert_equal " dtrace:::BEGIN\n              { \n          \t     printf(\"Tracing... Hit Ctrl-C to end.\\n\");\n \n              }\n ", @strategy.setup
  end
  
  test "should be able to yield a function entry definition" do
    assert_match /ruby_xrealloc:entry/, @strategy.entry
    assert_equal " pid$target::ruby_xrealloc:entry\n          {\n          \t self->depth++;\n            \t     self->exclude[self->depth] = 0;\n            \t     self->ruby_xrealloc[self->depth] = timestamp; \n          }\n ", @strategy.entry
  end
  
  test "should be able to yield a function return definition" do
    assert_match /ruby_xrealloc:return/, @strategy.return 
    assert_equal " pid$target::ruby_xrealloc:return\n             /self->ruby_xrealloc[self->depth]/\n          {\n          \t this->elapsed_incl = timestamp - self->ruby_xrealloc[self->depth];\n                   this->elapsed_excl = this->elapsed_incl - self->exclude[self->depth];\n                \t self->ruby_xrealloc[self->depth] = 0;\n                \t self->exclude[self->depth] = 0;\n                \t this->type = probefunc;\nthis->arg0 = arg0;\nthis->arg1 = stringof( arg1 );\n                \t @num[this->type, this->arg0, this->arg1] = count();\n                \t @types_incl[this->type, this->arg0, this->arg1] = sum(this->elapsed_incl);\n                \t @types_excl[this->type, this->arg0, this->arg1] = sum(this->elapsed_excl);\n\n                \t self->depth--;\n                \t self->exclude[self->depth] += this->elapsed_incl; \n          }\n ", @strategy.return
  end  

  test "should be able to yield a reporting function" do
    assert_match /END/, @strategy.report
    assert_equal  " dtrace:::END\n              {\n                 printf(\"\\nCount,\\n\");\n                   printf(\"   %-10s %-10s %8s\\n\", \"Probe\", \"arg0\", \"COUNT\");\n              \t   printa(\"   %-10s %-10s %@8d\\n\", @num);\n\n              \t   normalize(@types_excl, 1000);\n              \t   printf(\"\\nExclusive function elapsed times (us),\\n\");\n              \t   printf(\"   %-10s %-10s %8s\\n\", \"Probe\", \"arg0\", \"TOTAL\");\n              \t   printa(\"   %-10s %-10s %@8d\\n\", @types_excl);\n\n              \t   normalize(@types_incl, 1000);\n              \t   printf(\"\\nInclusive function elapsed times (us),\\n\");\n              \t   printf(\"   %-10s %-10s %8s\\n\", \"Probe\", \"arg0\", \"TOTAL\");\n              \t   printa(\"   %-10s %-10s %@8d\\n\", @types_incl); \n              }\n ", @strategy.report
  end  
  
end  