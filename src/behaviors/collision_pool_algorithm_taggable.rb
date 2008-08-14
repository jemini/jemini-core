require 'behaviors/collision_pool_algorithm'
class CollisionPoolAlgorithmTaggable < CollisionPoolAlgorithm
  depends_on :Taggable
  declared_methods :get_collision_candidates, :collides_with_tags
  
  def collides_with_tags(*tags)
    @tags = tags
  end
  
  def get_collision_candidates
    state.manager(:tag).find_by_any_tags(*@tags)#.each {|collidable| collision_check collidable }
  end
end