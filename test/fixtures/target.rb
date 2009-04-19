class Target
  
  def initialize( runs )
    @runs = runs
  end
  
  def run!
    @runs.times do
      Time.now
    end  
  end
  
end

Target.new(1000).run!