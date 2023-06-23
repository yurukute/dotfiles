BUILD ?=
BUILD_DIR = ./${BUILD}/build
OBJ_DIR   = ./${BUILD}/bin
INCL_DIR  = ./include
SRC_DIR   = ./src

LIB_DIR   = ../lib

EXEC = $(BUILD_DIR)/a.out
SRCS = $(wildcard $(SRC_DIR)/*.cpp)
OBJS = $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRCS))

CXXFLAGS.      = -I$(INCL_DIR) -Wall -g # C++ compiler flags
CXXFLAGS.debug =  $(CXXFLAGS.) -DDEBUG
LDLIBS         = -lstdc++ # Load libraries

.PHONY: all run clean

all: $(EXEC)

$(EXEC): $(OBJS) | $(BUILD_DIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS.$(BUILD)) -c -o $@ $<

$(BUILD_DIR) $(OBJ_DIR) $(LIB_DIR):
	mkdir -p $@

run: $(EXEC)
	$<

clean:
	rm -rf $(OBJ_DIR) $(BUILD_DIR)