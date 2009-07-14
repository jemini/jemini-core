class ParticleEmitter < Gemini::Behavior
  has_behavior :Updates

  java_import 'org.newdawn.slick.particles.ConfigurableEmitter'
  java_import 'org.newdawn.slick.particles.ParticleSystem'
  
  def load
    on_update {|delta| update_particle(delta)}
  end

  def load_particle_data(resource)
    @system = ParticleSystem.new(resource)
    
  end

  def draw(graphics)
    # use ConfigurableEmitter's angularOffset public field to apply rotation
    # this may be a poor system considering it may not respect the openGL graphics/transform stack
    
  end

private
  def update_particle(delta)
    return if @system.nil?
    
  end
end