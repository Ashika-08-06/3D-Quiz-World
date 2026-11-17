extends CharacterBody3D

@export var speed := 5.0

var human_root: Node3D
var left_leg: Node3D
var right_leg: Node3D
var left_arm: Node3D
var right_arm: Node3D
var walk_time := 0.0


func _ready():
	add_to_group("player")
	_build_human()


func _physics_process(delta):
	var input := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)

	var direction := Vector3(-input.x, 0, -input.y)
	if direction.length() > 0:
		direction = direction.normalized()

		rotation.y = lerp_angle(
			rotation.y,
			atan2(-direction.x, -direction.z),
			0.15
		)

		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		walk_time += delta * 9.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed * 5.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, speed * 5.0 * delta)
		walk_time = 0.0

	move_and_slide()
	_animate_human(input.length() > 0)


func _build_human():
	var old_body = get_node_or_null("Body")
	if old_body:
		old_body.visible = false

	human_root = Node3D.new()
	human_root.name = "Human3DModel"
	add_child(human_root)

	var skin := StandardMaterial3D.new()
	skin.albedo_color = Color(0.72, 0.42, 0.25)
	var shirt := StandardMaterial3D.new()
	shirt.albedo_color = Color(0.08, 0.35, 0.8)
	var pants := StandardMaterial3D.new()
	pants.albedo_color = Color(0.08, 0.10, 0.16)
	var shoes := StandardMaterial3D.new()
	shoes.albedo_color = Color(0.04, 0.04, 0.04)
	var hair := StandardMaterial3D.new()
	hair.albedo_color = Color(0.10, 0.055, 0.025)

	var torso := MeshInstance3D.new()
	var torso_mesh := CapsuleMesh.new()
	torso_mesh.radius = 0.48
	torso_mesh.height = 1.15
	torso.mesh = torso_mesh
	torso.position.y = 1.25
	torso.material_override = shirt
	human_root.add_child(torso)

	var head := MeshInstance3D.new()
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.38
	head_mesh.height = 0.76
	head.mesh = head_mesh
	head.position.y = 2.15
	head.material_override = skin
	human_root.add_child(head)

	var hair_cap := MeshInstance3D.new()
	var hair_mesh := SphereMesh.new()
	hair_mesh.radius = 0.40
	hair_mesh.height = 0.35
	hair_cap.mesh = hair_mesh
	hair_cap.position.y = 2.40
	hair_cap.scale = Vector3(1.0, 0.7, 1.0)
	hair_cap.material_override = hair
	human_root.add_child(hair_cap)

	left_leg = _limb("LeftLeg", Vector3(-0.20, 0.52, 0), 0.72, pants)
	right_leg = _limb("RightLeg", Vector3(0.20, 0.52, 0), 0.72, pants)
	left_arm = _limb("LeftArm", Vector3(-0.62, 1.35, 0), 0.75, skin)
	right_arm = _limb("RightArm", Vector3(0.62, 1.35, 0), 0.75, skin)

	var left_shoe := _box_part("LeftShoe", Vector3(-0.20, 0.13, -0.12), Vector3(0.34, 0.18, 0.48), shoes)
	var right_shoe := _box_part("RightShoe", Vector3(0.20, 0.13, -0.12), Vector3(0.34, 0.18, 0.48), shoes)
	human_root.add_child(left_shoe)
	human_root.add_child(right_shoe)


func _limb(part_name: String, pos: Vector3, length: float, material: Material) -> Node3D:
	var pivot := Node3D.new()
	pivot.name = part_name
	pivot.position = pos
	human_root.add_child(pivot)

	var mesh_node := MeshInstance3D.new()
	var mesh := CapsuleMesh.new()
	mesh.radius = 0.14
	mesh.height = length
	mesh_node.mesh = mesh
	mesh_node.position.y = -length * 0.5
	mesh_node.material_override = material
	pivot.add_child(mesh_node)
	return pivot


func _box_part(part_name: String, pos: Vector3, size: Vector3, material: Material) -> MeshInstance3D:
	var mesh_node := MeshInstance3D.new()
	mesh_node.name = part_name
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_node.mesh = mesh
	mesh_node.position = pos
	mesh_node.material_override = material
	return mesh_node


func _animate_human(walking: bool):
	if not human_root:
		return
	if walking:
		var swing := sin(walk_time) * 0.45
		left_leg.rotation.x = swing
		right_leg.rotation.x = -swing
		left_arm.rotation.x = -swing * 0.7
		right_arm.rotation.x = swing * 0.7
		human_root.position.y = sin(walk_time * 2.0) * 0.025
	else:
		left_leg.rotation.x = lerp(left_leg.rotation.x, 0.0, 0.2)
		right_leg.rotation.x = lerp(right_leg.rotation.x, 0.0, 0.2)
		left_arm.rotation.x = lerp(left_arm.rotation.x, 0.0, 0.2)
		right_arm.rotation.x = lerp(right_arm.rotation.x, 0.0, 0.2)
		human_root.position.y = lerp(human_root.position.y, 0.0, 0.2)
