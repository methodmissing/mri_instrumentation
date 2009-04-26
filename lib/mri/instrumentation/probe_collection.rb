module Mri
  module Instrumentation
    class ProbeCollection < Array
 
      # Find the largest argument count across all probes
      #
      def arguments_size
        self.max{|a,b| a.argument_size <=> b.argument_size }.argument_size
      end
      
      # Find the largest length across all probes
      #
      def length
        self.max{|a,b| a.length <=> b.length }.length
      end      
      
      # Columns header for the report
      #
      def report_header
        @report_header ||= ["\"Probe\""].concat( header_arguments ).compact.join( ", " )
      end

      # Format string representation accross all probes
      #
      def format_string( suffix = '', join_with = ' ', method = :to_s )
        self.map{|p| p.format_string( suffix, method ) }.join( join_with )
      end  

      # String representation across all probes
      #
      def to_s( suffix = '', join_with = ' ', wrap = '' )
        self.map{|p| "#{wrap}#{p.to_s( suffix )}#{wrap}" }.join( join_with )
      end

      # Description across all probes
      #
      def description( suffix = '', join_with = ' ', wrap = '' )
        self.map{|p| "#{wrap}#{p.description( suffix )}#{wrap}" }.join( join_with )
      end

      # Sprintf formatting for the header
      #
      def header_format
        ( format <<  '%20s' ).join(' ')
      end
      
      # Sprintf formatting for the report
      #
      def report_format
        ( format << '%@20d' ).join(' ')
      end      
      
      # Result format across all probes
      #
      def result_format
        format( '%6d', self.size ).join(' ') 
      end  
      
      # Is all of the returns void ?
      #        
      def void?
        @void ||= self.all?{|p| p.void? }
      end
      
      private
      
        # Arguments for the report header
        #
        def header_arguments
          if arguments_size == 1
            [nil]
          else    
            (0..(arguments_size-2)).to_a.map{|a| "\"arg#{a.to_s}\"" }
          end
        end
      
        # Format string helper
        #
        def format( string = '%-24s', multiplyer = arguments_size )
          [string] * multiplyer 
        end
      
    end  
  end
end