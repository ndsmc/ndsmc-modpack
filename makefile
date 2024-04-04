BASE_VERSIONS := versions/base
OTHER_VERSIONS := $(wildcard versions/*)

define create_symlinks
	$(foreach file,$(wildcard $(BASE_VERSIONS)/$(1)/$(2)/*), \
		$(foreach version,$(filter-out $(BASE_VERSIONS)/$(1)/$(2),$(OTHER_VERSIONS)), \
			$(eval target_dir := $(version)/$(1)/$(2)) \
			$(shell mkdir -p $(addprefix $(target_dir)/, mods config/yosbr/config)) \
			$(foreach modfile,$(wildcard $(BASE_VERSIONS)/$(1)/$(2)/mods/*), \
				$(if $(wildcard $(addprefix $(target_dir)/, mods/$(notdir $(modfile)))), \
					, \
					$(shell ln -sfn ../../../../../$(BASE_VERSIONS)/$(1)/$(2)/mods/$(notdir $(modfile)) $(addprefix $(target_dir)/, mods)/$(notdir $(modfile))) \
				) \
			) \
			$(foreach configfile,$(wildcard $(BASE_VERSIONS)/$(1)/$(2)/config/*), \
				$(if $(wildcard $(addprefix $(target_dir)/, config/$(notdir $(configfile)))), \
					, \
					$(shell ln -sfn ../../../../../$(BASE_VERSIONS)/$(1)/$(2)/config/$(notdir $(configfile)) $(addprefix $(target_dir)/, config)/$(notdir $(configfile))) \
				) \
			) \
			$(foreach yosbrconfigfile,$(wildcard $(BASE_VERSIONS)/$(1)/$(2)/config/yosbr/config/*), \
				$(if $(wildcard $(addprefix $(target_dir)/, config/yosbr/config/$(notdir $(yosbrconfigfile)))), \
					, \
					$(shell ln -sfn ../../../../../../../$(BASE_VERSIONS)/$(1)/$(2)/config/yosbr/config/$(notdir $(yosbrconfigfile)) $(addprefix $(target_dir)/, config/yosbr/config)/$(notdir $(yosbrconfigfile))) \
				) \
			) \
			$(foreach yosbrfile,$(wildcard $(BASE_VERSIONS)/$(1)/$(2)/config/yosbr/*), \
				$(if $(wildcard $(addprefix $(target_dir)/, config/yosbr/$(notdir $(yosbrfile)))), \
					, \
					$(shell ln -sfn ../../../../../../$(BASE_VERSIONS)/$(1)/$(2)/config/yosbr/$(notdir $(yosbrfile)) $(addprefix $(target_dir)/, config/yosbr)/$(notdir $(yosbrfile))) \
				) \
			) \
			$(if $(wildcard $(addprefix $(target_dir)/, $(notdir $(file)))), \
				, \
				$(shell ln -sfn ../../../../$(BASE_VERSIONS)/$(1)/$(2)/$(notdir $(file)) $(target_dir)/$(notdir $(file))) \
			) \
		) \
	)
endef

create-links-fabric:
	$(call create_symlinks,fabric,1.20.4)

create-links: create-links-fabric

update-packwiz:
	go install github.com/packwiz/packwiz@latest
	go install github.com/Merith-TK/packwiz-wrapper/cmd/pw@main
	clear
	@echo "Packwiz has been Updated"

export-%:
	mkdir -p .build/$(subst -,/,$*)
	cd versions/$(subst -,/,$*) && pw batch mr export
	mv versions/$(subst -,/,$*)/*/*.mrpack .build/$(subst -,/,$*)

update-%:
	cd versions/$(subst -,/,$*) && pw batch update --all

refresh-%:
	cd versions/$(subst -,/,$*) && pw batch refresh

refresh: refresh-base-fabric refresh-debug-fabric refresh-lite-fabric

update: update-base-fabric

export: export-base-fabric
