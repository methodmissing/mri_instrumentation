module Mri
  module Instrumentation
    class ProbeCollection < Array
 
      # Find the largest argument count across all probes
      #
      def arguments_size
        @arguments_size ||= self.max{|a,b| a.argument_size <=> b.argument_size }.argument_size
      end
      
      # Columns header for the report
      #
      def report_header
        @report_header ||= ["\"Probe\""].concat( header_arguments ).compact.join( ", " )
      end

      # Sprintf formatting for the header
      #
      def header_format
        @header_format ||= ( format <<  '%8s' ).join(' ')
      end
      
      # Sprintf formatting for the report
      #
      def report_format
        @report_format ||= ( format << '%@8d' ).join(' ')
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
        def format
          ['%-10s'] * arguments_size
        end
      
    end  
  end
end