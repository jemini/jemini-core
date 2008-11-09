#TODO: Remove this game object once we can detect when behaviors have been added to game objects
class TangibleObject < Gemini::GameObject
  has_behavior :Tangible
end