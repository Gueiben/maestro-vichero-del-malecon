extends Node3D

# Controlador Principal de Godot 4.3 para Maestro Vichero del Malecon 3D
# Simulador en primera persona con Paila de Cobre, Alambique, Botellas Torneadas y Clientes 3D Esculpidos.

var tex_adoquin: Texture2D
var tex_catedral: Texture2D
var tex_madera_casa: Texture2D
var tex_colonial: Texture2D
var tex_rio: Texture2D
var tex_chonta: Texture2D
var tex_borojo: Texture2D
var tex_popocho: Texture2D
var tex_viche: Texture2D
var tex_palma_tronco: Texture2D
var tex_palma_hoja: Texture2D
var tex_madera_muelle: Texture2D
var tex_paila: Texture2D
var tex_personaje: Texture2D

var cam: Camera3D
var held_root: Node3D
var npcs: Array[Node3D] = []
var time_elapsed: float = 0.0
var money_cop: int = 145
var rep_pts: int = 220

func _ready() -> void:
    _load_painted_assets()
    _setup_sunset_environment()
    _build_vichero_stall_and_malecon()
    _setup_first_person_camera()
    _setup_hud()

func _load_painted_assets() -> void:
    tex_adoquin = load("res://assets/textures/tex_adoquin_malecon.png")
    tex_catedral = load("res://assets/textures/tex_catedral_quibdo.png")
    tex_madera_casa = load("res://assets/textures/tex_casa_quibdo_madera.png")
    tex_colonial = load("res://assets/textures/tex_casa_colonial.png")
    tex_rio = load("res://assets/textures/tex_rio_atrato.png")
    tex_chonta = load("res://assets/textures/tex_chontaduro_skin.png")
    tex_borojo = load("res://assets/textures/tex_borojo_skin.png")
    tex_popocho = load("res://assets/textures/tex_popocho_skin.png")
    tex_viche = load("res://assets/textures/tex_botella_viche.png")
    tex_palma_tronco = load("res://assets/textures/tex_palma_tronco.png")
    tex_palma_hoja = load("res://assets/textures/tex_palma_hoja.png")
    tex_madera_muelle = load("res://assets/textures/tex_madera_muelle.png")
    tex_paila = load("res://assets/textures/tex_paila_cobre.png")
    tex_personaje = load("res://assets/textures/tex_personajes_quibdo.png")

func _make_mat(tex: Texture2D, tint: Color = Color(1, 1, 1, 1), uv_scale: Vector3 = Vector3(1, 1, 1)) -> StandardMaterial3D:
    var mat := StandardMaterial3D.new()
    mat.albedo_texture = tex
    mat.albedo_color = tint
    mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
    mat.roughness = 0.76
    mat.uv1_scale = uv_scale
    return mat

func _setup_sunset_environment() -> void:
    var env := Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color(0.85, 0.36, 0.18)
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.98, 0.78, 0.58)
    env.ambient_light_energy = 0.75
    env.fog_enabled = true
    env.fog_light_color = Color(0.90, 0.46, 0.26)
    env.fog_density = 0.007

    var we := WorldEnvironment.new()
    we.environment = env
    add_child(we)

    var sun := DirectionalLight3D.new()
    sun.light_color = Color(1.0, 0.86, 0.64)
    sun.light_energy = 1.45
    sun.rotation_degrees = Vector3(-34.0, -24.0, 0.0)
    sun.shadow_enabled = true
    add_child(sun)

func _instantiate_glb(glb_name: String, pos: Vector3, sc: Vector3, rot_y: float = 0.0, parent_node: Node3D = null) -> Node3D:
    var scene_res = load("res://assets/models/" + glb_name + ".glb")
    if scene_res:
        var inst: Node3D = scene_res.instantiate()
        inst.position = pos
        inst.scale = sc
        inst.rotation.y = rot_y
        if parent_node:
            parent_node.add_child(inst)
        else:
            add_child(inst)
        return inst
    return null

func _build_vichero_stall_and_malecon() -> void:
    # 1. Adoquin Terracota del Malecon de Quibdo (CERO verde)
    var floor_mi := MeshInstance3D.new()
    var f_box := BoxMesh.new()
    f_box.size = Vector3(72.0, 0.4, 72.0)
    floor_mi.mesh = f_box
    floor_mi.position = Vector3(0, -0.2, 0)
    floor_mi.material_override = _make_mat(tex_adoquin, Color(1.0, 0.94, 0.86), Vector3(22, 22, 1))
    add_child(floor_mi)

    # 2. Piso de Madera del Puesto Vichero
    var stall_floor := MeshInstance3D.new()
    var sf_box := BoxMesh.new()
    sf_box.size = Vector3(8.4, 0.12, 6.4)
    stall_floor.mesh = sf_box
    stall_floor.position = Vector3(0, 0.04, 0)
    stall_floor.material_override = _make_mat(tex_madera_muelle, Color(1, 0.95, 0.88), Vector3(4, 3, 1))
    add_child(stall_floor)

    # 3. Mostrador Principal de Madera con Textura Pintada
    var counter := MeshInstance3D.new()
    var c_box := BoxMesh.new()
    c_box.size = Vector3(5.2, 1.08, 0.92)
    counter.mesh = c_box
    counter.position = Vector3(0, 0.54, -2.5)
    counter.material_override = _make_mat(tex_madera_muelle, Color(1.0, 0.92, 0.80), Vector3(3, 1, 1))
    add_child(counter)

    # 4. Estacion Izquierda: Paila de Cobre Chocoana (.glb) y Alambique Artesanal (.glb)
    _instantiate_glb("paila_cobre_fogon", Vector3(-2.3, 0.65, -0.8), Vector3(0.95, 0.95, 0.95), 0.0)
    _instantiate_glb("alambique_artesanal", Vector3(-2.4, 0.55, 0.8), Vector3(0.85, 0.85, 0.85), 0.0)
    for c in range(4):
        _instantiate_glb("chontaduro_boraudo", Vector3(-2.3 + (c - 1.5) * 0.24, 1.18, -0.8), Vector3(0.35, 0.35, 0.35), float(c))

    # 5. Estacion Derecha: Estanteria de Botellas Torneadas de Viche (.glb) y Frutas Esculpidas
    var shelf := MeshInstance3D.new()
    var s_box := BoxMesh.new()
    s_box.size = Vector3(1.1, 1.35, 3.2)
    shelf.mesh = s_box
    shelf.position = Vector3(2.4, 0.68, -0.6)
    shelf.material_override = _make_mat(tex_madera_muelle, Color(0.95, 0.85, 0.72), Vector3(2, 2, 2))
    add_child(shelf)

    for b in range(5):
        var bz := -1.6 + float(b) * 0.55
        _instantiate_glb("botella_viche_arrechon", Vector3(2.2, 1.36, bz), Vector3(0.42, 0.42, 0.42), float(b) * 0.5)
        _instantiate_glb("chontaduro_boraudo", Vector3(0.6 + float(b) * 0.32, 1.18, -2.5), Vector3(0.32, 0.32, 0.32), float(b))

    # 6. Catedral de San Francisco de Asis de Quibdo (.glb) al fondo de la Plaza
    _instantiate_glb("catedral_quibdo", Vector3(0.0, 0.0, -21.0), Vector3(1.05, 1.05, 1.05), 0.0)

    # 7. Casas Coloniales de Alameda Reyes flanqueando la plaza
    for side in [-1.0, 1.0]:
        var h_mi := MeshInstance3D.new()
        var h_box := BoxMesh.new()
        h_box.size = Vector3(7.2, 6.6, 6.2)
        h_mi.mesh = h_box
        h_mi.position = Vector3(side * 13.5, 3.3, -12.0)
        h_mi.material_override = _make_mat(tex_madera_casa if side < 0 else tex_colonial, Color(1, 1, 1), Vector3(2, 2, 2))
        add_child(h_mi)

    # 8. Clientes Chocoanos Esculpidos (.glb) frente al mostrador (Janfry, Jonyer, Dona Cruz)
    var npc_coords := [
        Vector3(-0.3, 0.0, -4.1),
        Vector3(-1.6, 0.0, -4.8),
        Vector3(1.5, 0.0, -4.7)
    ]
    for pos in npc_coords:
        var npc := _instantiate_glb("personaje_quibdo", pos, Vector3(1.05, 1.05, 1.05), 0.0)
        if npc:
            npcs.append(npc)

func _setup_first_person_camera() -> void:
    cam = Camera3D.new()
    cam.fov = 62.0
    add_child(cam)
    cam.look_at_from_position(Vector3(0.0, 1.78, 1.35), Vector3(0.0, 1.45, -6.0), Vector3.UP)

    # Botella de Viche Esculpida y Chontaduro en manos 3D (Primera Persona)
    held_root = Node3D.new()
    cam.add_child(held_root)
    _instantiate_glb("botella_viche_arrechon", Vector3(0.45, -0.42, -0.85), Vector3(0.28, 0.28, 0.28), 0.4, held_root)
    _instantiate_glb("chontaduro_boraudo", Vector3(-0.42, -0.35, -0.82), Vector3(0.26, 0.26, 0.26), -0.3, held_root)

func _setup_hud() -> void:
    var canvas := CanvasLayer.new()
    add_child(canvas)

    var top_panel := PanelContainer.new()
    top_panel.position = Vector2(18, 14)
    top_panel.custom_minimum_size = Vector2(710, 92)
    canvas.add_child(top_panel)

    var lbl := Label.new()
    lbl.text = "MAESTRO VICHERO DEL MALECON 3D [GODOT ENGINE 4.3]
CAJA: $145 COP | REPUTACION: 220 PTS | PAILA DE COBRE: LISTA [E] | ALAMBIQUE: LISTO [E]
CLIENTES EN FILA: JANFRY, JONYER Y DONA CRUZ (MODELOS 3D ESCULPIDOS + TEXTURAS UV)"
    lbl.add_theme_color_override("font_color", Color(1.0, 0.94, 0.82))
    lbl.add_theme_font_size_override("font_size", 15)
    top_panel.add_child(lbl)

func _process(delta: float) -> void:
    time_elapsed += delta
    if held_root:
        held_root.position.y = sin(time_elapsed * 4.0) * 0.02
