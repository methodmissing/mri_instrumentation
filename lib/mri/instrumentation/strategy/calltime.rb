module Mri
  module Instrumentation
    module Strategy
      class Calltime < Base
        
        def setup( contents = '' )
          super %[ printf("Tracing... Hit Ctrl-C to end.\\n");\n ]          
        end
        
        def entry( contents = '' )
          super %[ self->depth++;
            	     self->exclude[self->depth] = 0;
            	     #{assign_arguments}
            	     @num[#{arguments_list( arguments_size )}] = count();
            	     self->#{name}[self->depth] = timestamp; ]
            	     
        end
        
        def predicate
          "/self->#{name}[self->depth]/"
        end
        
        def return( contents = '' )
          super %[ this->elapsed_incl = timestamp - self->#{name}[self->depth];
                   this->elapsed_excl = this->elapsed_incl - self->exclude[self->depth];
                	 self->#{name}[self->depth] = 0;
                	 self->exclude[self->depth] = 0;
                	 #{assign_arguments}
                	 @types_incl[#{arguments_list( arguments_size )}] = sum(this->elapsed_incl);
                	 @types_excl[#{arguments_list( arguments_size )}] = sum(this->elapsed_excl);

                	 self->depth--;
                	 self->exclude[self->depth] += this->elapsed_incl; ]
        end        
        
        def report( contents = '' )
          super %[ printf("\\nCount,\\n");
                   printf("   #{header_format}\\n", #{report_header}, "COUNT");
              	   printa("   #{report_format}\\n", @num);
                   #{exclusive_and_inclusive} ]  
        end  
        
        private
        
          def exclusive_and_inclusive
            if void?
              ''
            else  
              %[ normalize(@types_excl, 1000);
          	     printf("\\nExclusive function elapsed times (us),\\n");
          	     printf("   #{header_format}\\n", #{report_header}, "TOTAL");
          	     printa("   #{report_format}\\n", @types_excl);

          	     normalize(@types_incl, 1000);
          	     printf("\\nInclusive function elapsed times (us),\\n");
          	     printf("   #{header_format}\\n", #{report_header}, "TOTAL");
          	     printa("   #{report_format}\\n", @types_incl); ]
            end
          end  
        
      end  
    end
  end
end