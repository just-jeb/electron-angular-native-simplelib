simple_library_name = simplelib
simple_library_objects = LinkProvider.o

INCLUDES = \

CPPFLAGS_BASE = -Wall -Werror -fPIC

LDFLAGS_BASE = -Wall -fPIC -Wls

OS = $(shell uname)

NATIVE_ARTIFACTS_DIR = ./bin

ifeq ($(OS),Darwin)
	OS = darwin
	LDFLAGS_BASE += -dynamiclib
	simple_library = $(simple_library_name).dylib
else
	LDFLAGS_BASE += -shared
	simple_library = $(simple_library_name).so
endif

32bit: CPPFLAGS = $(CPPFLAGS_BASE) -m32
32bit: LDFLAGS = $(LDFLAGS_BASE) -m32
32bit: OUTPUT_DIR = $(NATIVE_ARTIFACTS_DIR)/ia32/$(OS)
32bit: clean_objects $(simple_library)

64bit: CPPFLAGS = $(CPPFLAGS_BASE) -m64
64bit: LDFLAGS = $(LDFLAGS_BASE) -m64
64bit: OUTPUT_DIR =  $(NATIVE_ARTIFACTS_DIR)/x64/$(OS)
64bit: clean_objects $(simple_library)

$(simple_library): $(simple_library_objects)
	$(CXX) $^ $(LDFLAGS) -o $(OUTPUT_DIR)/$@

%.o: %.cpps
	$(CXX) -c $(CPPFLAGS) $(DEFS) $(INCLUDES) $^


clean_objects:
	rm -f *.o

clean: clean_objects
	rm -f  $(OUTPUT_DIR)/$(simple_library)


