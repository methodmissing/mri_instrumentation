module Mri
  module Instrumentation
    class ProbeCollection < Array
 
      # Find the largest argument count across all probes
      #
      def argument_size
        @argument_size ||= self.max{|a,b| a.argument_size <=> b.argument_size }.argument_size
      end
      
      # Columns header for the report
      #
      def report_header
        @report_header ||= ["\"Probe\""].concat( header_arguments ).join( ", " )
      end

      # Sprintf formatting for the header
      #
      def header_format
        @header_format ||= ( format << '%8s' ).join(' ')
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
          (0..(argument_size-1)).to_a.map{|a| "\"arg#{a.to_s}\"" }
        end
      
        # Format string helper
        #
        def format
          ['%-10s'] * argument_size
        end
      
    end  
  end
end