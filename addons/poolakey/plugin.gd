@tool
extends EditorPlugin

var export_plugin : AndroidExportPlugin

func _enter_tree():
	export_plugin = AndroidExportPlugin.new()
	add_export_plugin(export_plugin)

func _exit_tree():
	export_plugin = null

class AndroidExportPlugin extends EditorExportPlugin:
	var _plugin_name = "GodotPoolakey"

	func _supports_platform(platform):
		if platform is EditorExportPlatformAndroid:
			return true
		return false

	func _get_android_libraries(platform, debug):
		if debug:
			return PackedStringArray(["poolakey/bin/GodotPoolakey-debug.aar"])
		else:
			return PackedStringArray(["poolakey/bin/GodotPoolakey-release.aar"])

	func _get_android_dependencies(platform, debug):
		return PackedStringArray(["com.github.cafebazaar.Poolakey:poolakey:2.2.0"])

	func _get_android_dependencies_maven_repos(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
		return PackedStringArray(["https://jitpack.io"])

	func _get_name():
		return _plugin_name
