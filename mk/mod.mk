$(MOD)_OBJS     := $(patsubst %.c,$(BUILD)/modules/$(MOD)/%.o,\
	$(filter %.c,$($(MOD)_SRCS)))
$(MOD)_OBJS     += $(patsubst %.cpp,$(BUILD)/modules/$(MOD)/%.o,\
	$(filter %.cpp,$($(MOD)_SRCS)))
$(MOD)_OBJS     += $(patsubst %.m,$(BUILD)/modules/$(MOD)/%.o,\
	$(filter %.m,$($(MOD)_SRCS)))
$(MOD)_OBJS     += $(patsubst %.S,$(BUILD)/modules/$(MOD)/%.o,\
	$(filter %.S,$($(MOD)_SRCS)))

-include $($(MOD)_OBJS:.o=.d)


$(MOD)_NAME := $(MOD)

#
# function to extract the name of the module from the file/dir path
#
modulename = $(lastword $(subst /, ,$(dir $1)))

#
# Static linking of modules
#

# needed to deref variable now, append to list
MOD_OBJS        := $(MOD_OBJS) $($(MOD)_OBJS)
MOD_LFLAGS      := $(MOD_LFLAGS) $($(MOD)_LFLAGS)

$(BUILD)/modules/$(MOD)/%.o: modules/$(MOD)/%.c $(BUILD) Makefile mk/mod.mk \
				modules/$(MOD)/module.mk mk/modules.mk
	@echo "  CC [m]  $@"
	@mkdir -p $(dir $@)
	$(HIDE)$(CC) $(CFLAGS) $($(call modulename,$@)_CFLAGS) \
		-DMOD_NAME=\"$(MOD)\" -c $< -o $@ $(DFLAGS)

$(BUILD)/modules/$(MOD)/%.o: modules/$(MOD)/%.m $(BUILD) Makefile mk/mod.mk \
				modules/$(MOD)/module.mk mk/modules.mk
	@echo "  OC [m]  $@"
	@mkdir -p $(dir $@)
	$(HIDE)$(CC) $(CFLAGS) $($(call modulename,$@)_CFLAGS) $(OBJCFLAGS) \
		-DMOD_NAME=\"$(MOD)\" -c $< -o $@ $(DFLAGS)


$(BUILD)/modules/$(MOD)/%.o: modules/$(MOD)/%.cpp $(BUILD) Makefile mk/mod.mk \
				modules/$(MOD)/module.mk mk/modules.mk
	@echo "  CXX [m] $@"
	@mkdir -p $(dir $@)
	$(HIDE)$(CXX) $(CXXFLAGS) $($(call modulename,$@)_CXXFLAGS) \
		-DMOD_NAME=\"$(MOD)\" -c $< -o $@ $(DFLAGS)

$(BUILD)/modules/$(MOD)/%.o: modules/$(MOD)/%.S $(BUILD) Makefile mk/mod.mk \
				modules/$(MOD)/module.mk mk/modules.mk
	@echo "  AS [m]  $@"
	@mkdir -p $(dir $@)
	$(HIDE)$(CC) $(CFLAGS) -DMOD_NAME=\"$(MOD)\" -c $< -o $@ $(DFLAGS)

