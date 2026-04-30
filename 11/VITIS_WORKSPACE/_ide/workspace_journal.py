# 2026-04-30T10:56:48.058595500
import vitis

client = vitis.create_client()
client.set_workspace(path="VITIS_WORKSPACE")

platform = client.create_platform_component(name = "platform",hw_design = "$COMPONENT_LOCATION/../../zynq.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",compiler = "gcc")

comp = client.create_app_component(name="hello_world",platform = "$COMPONENT_LOCATION/../platform/export/platform/platform.xpfm",domain = "standalone_ps7_cortexa9_0",template = "hello_world")

platform = client.get_component(name="platform")
status = platform.build()

status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

vitis.dispose()

