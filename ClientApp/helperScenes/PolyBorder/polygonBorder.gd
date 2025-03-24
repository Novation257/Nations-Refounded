extends Line2D

# Inherits the polygon shape of the parent Polygon2D
func _ready() -> void:
	var parentPolygon2D:Polygon2D = self.get_parent()
	self.points = parentPolygon2D.polygon
	self.add_point(parentPolygon2D.polygon[0])
	return
