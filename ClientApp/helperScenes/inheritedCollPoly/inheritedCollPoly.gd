extends CollisionPolygon2D

# Inherits the polygon shape of the parent Polygon2D
func _ready() -> void:
	var parentPolygon2D:Polygon2D = self.get_parent().get_parent()
	self.polygon = parentPolygon2D.polygon
	return
