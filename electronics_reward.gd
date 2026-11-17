extends MeshInstance3D

@export var zone_id: String = "electronics"


func _ready():
	visible = false
	QuizManager.zone_completed.connect(_on_zone_completed)
	_build_star_shape()


func _build_star_shape():
	var glow_material = StandardMaterial3D.new()
	glow_material.albedo_color = Color("#FFD700")
	glow_material.emission_enabled = true
	glow_material.emission = Color("#FFD700")
	glow_material.emission_energy_multiplier = 2.0

	# Center core — a small sphere
	var core_mesh = SphereMesh.new()
	core_mesh.radius = 0.22
	core_mesh.height = 0.44
	mesh = core_mesh
	material_override = glow_material

	# Float the whole reward above the floor
	position.y = 1.0

	# Star spikes — standing upright
	for i in range(4):
		var spike = MeshInstance3D.new()
		var spike_mesh = BoxMesh.new()
		spike_mesh.size = Vector3(1.0, 0.1, 0.1)
		spike.mesh = spike_mesh
		spike.material_override = glow_material
		spike.rotation_degrees.z = i * 45.0
		add_child(spike)


func _process(delta):
	if visible:
		rotate_y(delta * 1.5)


func _on_zone_completed(completed_zone):
	if completed_zone == zone_id:
		visible = true
		print("⚡ Electronics Reward unlocked!")
