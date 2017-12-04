
static func f_clamp(f, fMin, fMax):
	if f < fMin:
		f = fMin
	if f > fMax:
		f = fMax	
	return f

static func v2_clamp(v, xMin, xMax, yMin, yMax):
	if v.x < xMin:
		v.x = xMin
	if v.x > xMax:
		v.x = xMax
	if v.y < yMin:
		v.y = yMin
	if v.y > yMax:
		v.y = yMax
	return v
	
static func v2_aabb(v, x1, y1, x2, y2):
	if v.x < x1:
		return false
	if v.x > x2:
		return false
	if v.y < y1:
		return false
	if v.y > y2:
		return false
	return true
	
static func rot_to_vec(rot):
	return Vector2(cos(rot), -sin(rot))
	
static func vec_to_rot(v):
	return rot_norm(atan2(v.x, v.y) - PI/2)

static func rot_norm(rot):
	while rot > PI:
		rot -= 2*PI
	while rot < -PI:
		rot += 2*PI
	return rot
		
static func rot_delta(from, to):
	from = rot_norm(from)
	to = rot_norm(to)
	var result = rot_norm(to - from)
	return result
	
static func tween_color_perc(from, to, perc, delta):
	var r = from.r + (to.r - from.r) * perc * delta
	var g = from.g + (to.g - from.g) * perc * delta
	var b = from.b + (to.b - from.b) * perc * delta
	var a = from.a + (to.a - from.a) * perc * delta
	return Color(r, g, b, a)
	