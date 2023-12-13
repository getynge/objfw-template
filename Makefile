NAME=program
SRC=src
BUILD=build
# this is finding any files ending in .m or .c and replacing the extensions with .o
# any pathnames in the src directory are mirrored in the build directory
# The list of c++ extensions is intentionally non-exhaustive
OBJECTS=$(shell find \( -name "*.m" -or -name "*.c" -or -name "*.mm" -or -name "*.cpp" \) -type f -print |  sed 's/\n//g;s/$(SRC)\/\(.*\)/$(BUILD)\/\1.o/g')
OUT=$(NAME)
DOCKEROUT=docker-out
CC=clang
CFLAGS=--std=c17
CXXFLAGS=--std=c++20
LDLIBS=
LDFLAGS=
OBJFWLD=$(shell objfw-config --ldflags --libs)
OBJFWC=$(shell objfw-config --cflags --objcflags --arc)
OBJFWCXX=$(shell objfw-config --cppflags --objcflags --arc)

# build mirrors src, the below statement ensures that the mirrored directories exist prior to the build process starting
$(info $(shell rsync -a --include "*/" --exclude "*" "$(SRC)/" "$(BUILD)"))

.PHONY: all

all: $(OBJECTS)
	$(CC) $(LDLIBS) $(LDFLAGS) $(OBJFWLD) -o $(OUT) $^

$(BUILD)/%.c.o: $(SRC)/%.c
	$(CC) $(CFLAGS) $(OBJFWC) -o $@ -c $<

$(BUILD)/%.m.o: $(SRC)/%.m
	$(CC) $(CFLAGS) $(OBJFWC) -o $@ -c $<

$(BUILD)/%.cpp.o: $(SRC)/%.cpp
	$(CC) $(CXXFLAGS) $(OBJFWCXX) -o $@ -c $<

$(BUILD)/%.mm.o: $(SRC)/%.mm
	$(CC) $(CXXFLAGS) $(OBJFWCXX) -o $@ -c $<

docker:
	docker build --build-arg name=$(NAME) --output=$(DOCKEROUT) --target=output .

clean:
	@rm -rf $(BUILD) $(OUT) $(DOCKEROUT)
