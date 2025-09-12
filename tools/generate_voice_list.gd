@tool
extends EditorScript

# Dossier à scanner
const VOICE_DIR := "res://assets/sfx/real_voice"

func _run():
	var dir = DirAccess.open(VOICE_DIR)
	if not dir:
		push_error("Dossier introuvable : %s" % VOICE_DIR)
		return

	var lines = []
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if not dir.current_is_dir() and file.to_lower().ends_with(".wav"):
			var path = "%s/%s" % [VOICE_DIR, file]
			lines.append('    preload("%s")' % path)
		file = dir.get_next()
	dir.list_dir_end()

	if lines.is_empty():
		push_warning("Aucun fichier .wav trouvé dans %s" % VOICE_DIR)
		return

	var output = "var voix = [\n%s\n]" % ",\n".join(lines)
	print("\n=== Liste générée ===\n%s\n" % output)
	print("💡 Copie-colle ce tableau dans ton script de jeu.")
