# define ANDROID_VERSION MAJOR, MINOR and PATCH

ANDROID_VERSION_MAJOR := $(word 1, $(subst ., , $(PLATFORM_VERSION)))
ANDROID_VERSION_MINOR := $(word 2, $(subst ., , $(PLATFORM_VERSION)))
ANDROID_VERSION_PATCH := $(word 3, $(subst ., , $(PLATFORM_VERSION)))

# PLATFORM_VERSION is a codename, not a number, on a development branch -
# "Baklava" for Android 16 under trunk_staging. Every comparison below is a
# shell "test N -ge M", which errors out on a non-numeric left hand side and is
# then treated as false, so the makefile silently takes its oldest branch. That
# is how a 16 tree ended up asking for libhwcomposer-command-buffer, a static
# library that has not existed since Android 8, and why the "-ge 16" gate added
# for Android 16 support could never fire.
#
# A codename is always newer than any released version, so substitute a value
# above every version tested here. That makes each -ge true and the single -le
# false, which is what a development branch should evaluate to.
ifeq ($(shell echo "$(ANDROID_VERSION_MAJOR)" | grep -qE '^[0-9]+$$' && echo numeric),)
$(warning libhybris: PLATFORM_VERSION "$(PLATFORM_VERSION)" is a codename; treating it as newer than any release)
ANDROID_VERSION_MAJOR := 99
endif

ifeq ($(ANDROID_VERSION_MINOR),)
    ANDROID_VERSION_MINOR := 0
endif
ifeq ($(ANDROID_VERSION_PATCH),)
    ANDROID_VERSION_PATCH := 0
endif

LOCAL_CFLAGS += \
	-DANDROID_VERSION_MAJOR=$(ANDROID_VERSION_MAJOR) \
	-DANDROID_VERSION_MINOR=$(ANDROID_VERSION_MINOR) \
	-DANDROID_VERSION_PATCH=$(ANDROID_VERSION_PATCH)
