::C::FunctionDef.class_eval do
  
  # Yields a Intrumentation::Probe instance
  #
  def to_probe( group )
    Mri::Instrumentation::Probe.new( group, 
                                     name, 
                                     name, 
                                     to_probe_arguments,
                                     type.type.to_s, 
                                     storage.to_s )
  end
  
  private
  
    # All params for this function definition
    #
    def probe_params
      @probe_params ||= type.params || []
    end
  
    # Generate Instrumentation::Argument instances
    #
    def to_probe_arguments
      probe_params.map do |param|
        Mri::Instrumentation::Argument.new( param.type.to_s, 
                                            param.name.to_s, 
                                            probe_params.index(param) )
      end    
    end  
  
end