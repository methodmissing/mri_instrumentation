require File.join( File.dirname( __FILE__ ), '..', '..', 'helper' )

class StrategyBuilderTest < Test::Unit::TestCase
  
  def setup
    @strategy = Mri::Instrumentation::Strategy::Calltime
    @probes = Mri::Instrumentation.probes( Mri::Instrumentation::Test::PROBES )
    @builder = Mri::Instrumentation::Strategy::Builder.new( @strategy, @probes)
  end
  
  test "should be able to build a D stream" do
    assert_equal "  #!/usr/sbin/dtrace -Zs \n             #pragma D option quiet\n\n             #pragma D option dynvarsize=64m\n\n             \n \n              dtrace:::BEGIN\n              { \n                 printf(\"Tracing... Hit Ctrl-C to end.\\n\");\n \n              }\n \n              pid$target::rb_memerror:entry\n             {\n                self->depth++;\n            \t     self->exclude[self->depth] = 0;\n            \t     this->type = probefunc;\n            \t     @num[this->type, \"\"] = count();\n            \t     self->rb_memerror[self->depth] = timestamp; \n              }\n  pid$target::rb_memerror:return\n             /self->rb_memerror[self->depth]/\n              {\n               \t this->elapsed_incl = timestamp - self->rb_memerror[self->depth];\n                   this->elapsed_excl = this->elapsed_incl - self->exclude[self->depth];\n                \t self->rb_memerror[self->depth] = 0;\n                \t self->exclude[self->depth] = 0;\n                \t this->type = probefunc;\n                \t @types_incl[this->type, \"\"] = sum(this->elapsed_incl);\n                \t @types_excl[this->type, \"\"] = sum(this->elapsed_excl);\n\n                \t self->depth--;\n                \t self->exclude[self->depth] += this->elapsed_incl; \n               }\n  pid$target::rb_newobj:entry\n             {\n                self->depth++;\n            \t     self->exclude[self->depth] = 0;\n            \t     this->type = probefunc;\n            \t     @num[this->type, \"\"] = count();\n            \t     self->rb_newobj[self->depth] = timestamp; \n              }\n  pid$target::rb_newobj:return\n             /self->rb_newobj[self->depth]/\n              {\n               \t this->elapsed_incl = timestamp - self->rb_newobj[self->depth];\n                   this->elapsed_excl = this->elapsed_incl - self->exclude[self->depth];\n                \t self->rb_newobj[self->depth] = 0;\n                \t self->exclude[self->depth] = 0;\n                \t this->type = probefunc;\n                \t @types_incl[this->type, \"\"] = sum(this->elapsed_incl);\n                \t @types_excl[this->type, \"\"] = sum(this->elapsed_excl);\n\n                \t self->depth--;\n                \t self->exclude[self->depth] += this->elapsed_incl; \n               }\n  pid$target::ruby_xmalloc:entry\n             {\n                self->depth++;\n            \t     self->exclude[self->depth] = 0;\n            \t     this->arg0 = stringof( arg0 );\nthis->type = probefunc;\n            \t     @num[this->type, this->arg0] = count();\n            \t     self->ruby_xmalloc[self->depth] = timestamp; \n              }\n  pid$target::ruby_xmalloc:return\n             /self->ruby_xmalloc[self->depth]/\n              {\n               \t this->elapsed_incl = timestamp - self->ruby_xmalloc[self->depth];\n                   this->elapsed_excl = this->elapsed_incl - self->exclude[self->depth];\n                \t self->ruby_xmalloc[self->depth] = 0;\n                \t self->exclude[self->depth] = 0;\n                \t this->arg0 = stringof( arg0 );\nthis->type = probefunc;\n                \t @types_incl[this->type, this->arg0] = sum(this->elapsed_incl);\n                \t @types_excl[this->type, this->arg0] = sum(this->elapsed_excl);\n\n                \t self->depth--;\n                \t self->exclude[self->depth] += this->elapsed_incl; \n               }\n \n              dtrace:::END\n              {\n                 printf(\"\\nCount,\\n\");\n                   printf(\"   %-24s %-24s %20s\\n\", \"Probe\", \"arg0\", \"COUNT\");\n              \t   printa(\"   %-24s %-24s %@20d\\n\", @num);\n                    normalize(@types_excl, 1000);\n          \t     printf(\"\\nExclusive function elapsed times (us),\\n\");\n          \t     printf(\"   %-24s %-24s %20s\\n\", \"Probe\", \"arg0\", \"TOTAL\");\n          \t     printa(\"   %-24s %-24s %@20d\\n\", @types_excl);\n\n          \t     normalize(@types_incl, 1000);\n          \t     printf(\"\\nInclusive function elapsed times (us),\\n\");\n          \t     printf(\"   %-24s %-24s %20s\\n\", \"Probe\", \"arg0\", \"TOTAL\");\n          \t     printa(\"   %-24s %-24s %@20d\\n\", @types_incl);  \n               }\n  ", @builder.to_s
  end
  
end  