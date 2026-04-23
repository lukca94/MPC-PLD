# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "C:\\Temp\\246892\\MPC-PLD\\10\\VITIS_WORKSPACE\\rp_pld\\microblaze_I\\standalone_microblaze_I\\bsp\\include\\sleep.h"
  "C:\\Temp\\246892\\MPC-PLD\\10\\VITIS_WORKSPACE\\rp_pld\\microblaze_I\\standalone_microblaze_I\\bsp\\include\\xiltimer.h"
  "C:\\Temp\\246892\\MPC-PLD\\10\\VITIS_WORKSPACE\\rp_pld\\microblaze_I\\standalone_microblaze_I\\bsp\\include\\xtimer_config.h"
  "C:\\Temp\\246892\\MPC-PLD\\10\\VITIS_WORKSPACE\\rp_pld\\microblaze_I\\standalone_microblaze_I\\bsp\\lib\\libxiltimer.a"
  )
endif()
