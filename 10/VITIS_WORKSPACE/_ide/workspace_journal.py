# 2026-04-23T10:45:59.132524700
import vitis

client = vitis.create_client()
client.set_workspace(path="VITIS_WORKSPACE")

platform = client.get_component(name="rp_pld")
status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

status = platform.build()

comp.build()

vitis.dispose()

