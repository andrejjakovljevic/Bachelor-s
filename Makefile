PROGRAM = server
BUILD_DIR = build

SOURCE_CU_LIST = \
src/BasicOperations.cu

SOURCE_CPP_LIST = \
src/BasicArray.cpp \
src/Server.cpp \
src/SymTab.cpp \
src/Users.cpp

INCLUDE_C_LIST = \
-Iinc -Inlohmann

OBJECTS_LIST = 
OBJECTS_LIST += $(addprefix $(BUILD_DIR)/, $(notdir $(SOURCE_CU_LIST:.cu=.o)))
OBJECTS_LIST += $(addprefix $(BUILD_DIR)/, $(notdir $(SOURCE_CPP_LIST:.cpp=.o)))
vpath %.cu $(sort $(dir $(SOURCE_CU_LIST)))
vpath %.cpp $(sort $(dir $(SOURCE_CPP_LIST)))

all : $(BUILD_DIR)/$(PROGRAM)

$(BUILD_DIR)/$(PROGRAM) : $(OBJECTS_LIST) Makefile
	nvcc -o $(@) $(OBJECTS_LIST)

$(BUILD_DIR)/%.o : %.cu Makefile | $(BUILD_DIR)
	nvcc -c -g $(INCLUDE_C_LIST) -o $(@) $(<)

$(BUILD_DIR)/%.o : %.cpp Makefile | $(BUILD_DIR)
	nvcc -c -g $(INCLUDE_C_LIST) -o $(@) $(<)
	
$(BUILD_DIR) :
	mkdir $(@)
	
clean :
	rm -rf $(BUILD_DIR)

-include $(wildcard $(BUILD_DIR)/*.d)
