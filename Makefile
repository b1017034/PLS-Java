SUFFIX   := .jar
COMPILER := tar

JARDIR   = lib/
SRCDIR   = src/
OUTDIR   = out/

SOURCES  = $(wildcard $(JARDIR)/*$(SUFFIX))
OBJECTS  = $(notdir $(SOURCES:$(SUFFIX)=.class))
TARGETS  = $(notdir $(basename $(SOURCES)))

JAR_DIR  = $(shell jar -tf $(JARDIR)/$(1)$(SUFFIX))
CLASS_DIR  = $(addsuffix .class,$(basename $(JAR_DIR)))
EXPORTS  = $(join $(JAR_DIR),  $(addsuffix .class,$(basename $(JAR_DIR))))

define IMPORTALL
@if [ -d $(addprefix $(SRCDIR),$(dir $(firstword $(JAR_DIR)))) ]; then \
	echo if you import $(1).jar, you should delete directory below.; \
	$(foreach VAR,$(addprefix $(SRCDIR),$(dir $(JAR_DIR))),echo "$(VAR)"); \
	\
else \
	echo ---------$(basename $(1))------------- ; \
	cd $(SRCDIR) && jar -xvf ../$(JARDIR)$(basename $(1))$(SUFFIX) ; \
	echo you can see $(SRCDIR) ; \
fi

endef

define EXPORTALL
$(1): $(1).class
	@echo $(filter-out test/%,$(JAR_DIR))
	cd $(SRCDIR) && jar -cvf ../$(OUTDIR)$(1).jar $(filter-out test/%,$(JAR_DIR)) $(filter-out test/%,$(CLASS_DIR))

$(1).class:
	@echo ---------$(basename $(1))-------------
	@echo $(JAR_DIR)
	javac $(addprefix $(SRCDIR),$(JAR_DIR)) -encoding utf8;
#	@$(foreach VAR,$(JAR_DIR), echo $(SRCDIR)$(VAR);  javac $(SRCDIR)$(VAR) -encoding utf8;)

endef

.PHONY: all
all: $(TARGETS)
$(foreach VAR,$(TARGETS),$(eval $(call EXPORTALL,$(VAR))))

.PHONY: import
import:
	$(foreach VAR,$(TARGETS),$(call IMPORTALL,$(VAR)))

.PHONY: clean
clean:
	rm -rf $(OUTDIR)*

.PHONY: no_targets__ list
no_targets__:
list:
	@echo $(JARDIR)
	@sh -c "$(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | sort"