if(USE_LIBSONIC)
find_library(SONIC_LIB sonic)
find_path(SONIC_INC "sonic.h")
endif(USE_LIBSONIC)

if(USE_LIBPCAUDIO)
find_library(PCAUDIO_LIB pcaudio)
find_path(PCAUDIO_INC "pcaudiolib/audio.h")
endif(USE_LIBPCAUDIO)

find_library(PTHREAD_LIB pthread)

if(USE_MBROLA)
find_program(MBROLA_BIN mbrola)
endif(USE_MBROLA)

include(FetchContent)

if (PTHREAD_LIB)
  set(HAVE_PTHREAD ON)
endif(PTHREAD_LIB)
if (MBROLA_BIN)
  set(HAVE_MBROLA ON)
endif(MBROLA_BIN)
if (SONIC_LIB AND SONIC_INC)
  set(HAVE_LIBSONIC ON)
elseif(USE_LIBSONIC)
  FetchContent_Declare(sonic-git
    GIT_REPOSITORY https://github.com/waywardgeek/sonic.git
    GIT_TAG fbf75c3d6d846bad3bb3d456cbc5d07d9fd8c104
  )
  FetchContent_MakeAvailable(sonic-git)
  FetchContent_GetProperties(sonic-git)
  add_library(sonic OBJECT ${sonic-git_SOURCE_DIR}/sonic.c)
  target_include_directories(sonic PUBLIC ${sonic-git_SOURCE_DIR})
  set(HAVE_LIBSONIC ON)
  set(SONIC_LIB sonic)
  set(SONIC_INC ${sonic-git_SOURCE_DIR})
else()
  set(HAVE_LIBSONIC OFF)
endif()
if (PCAUDIO_LIB AND PCAUDIO_INC)
  set(HAVE_LIBPCAUDIO ON)
endif()
