extends Polygon2D

# From https://forum.godotengine.org/t/how-to-shape-polygon2d-into-a-circle/15432/4
func generate_circle_polygon(radius: float, num_sides: int, position: Vector2) -> PackedVector2Array:
	var angle_delta: float = (PI * 2) / num_sides
	var vector: Vector2 = Vector2(radius, 0)
	var polygon: PackedVector2Array
	
	for _i in num_sides:
		polygon.append(vector + position)
		vector = vector.rotated(angle_delta)
	return polygon

func _init() -> void:
	self.polygon = generate_circle_polygon(self.scale[0]*100, 35*self.scale[0], self.position)
	return
