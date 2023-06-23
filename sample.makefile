DEBUG ?=
BUILD_DIR = ./build
SRC_DIR   = ./src
OBJ_DIR   = ./obj
INCL_DIR  = ./include
LIB_DR    = ./lib

CXXFLAGS.      = -g -Wall # C++ compiler flags
CXXFLAGS.debug = $(CXXFLAGS) -DDEBUG
LDLIBS         = -lstdc++ # Load libraries

.PHONY: all clean

all: $(BUILD_DIR)/server $(BUILD_DIR)/client

server: $(BUILD_DIR)/server
	$<

client: $(BUILD_DIR)/client
	$<

$(BUILD_DIR)/server: $(OBJ_DIR)/server.o | $(BUILD_DIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(BUILD_DIR)/client: $(OBJ_DIR)/client.o | $(BUILD_DIR)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(OBJ_DIR)/server.o: $(SRC_DIR)/server.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(OBJ_DIR)/client.o: $(SRC_DIR)/client.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(BUILD_DIR) $(OBJ_DIR):
	mkdir $@

clean:
	rm -rf $(OBJ_DIR) $(BUILD_DIR)