# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appnewMusicPlayer_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appnewMusicPlayer_autogen.dir/ParseCache.txt"
  "appnewMusicPlayer_autogen"
  )
endif()
