create-links:
	python3 create-links.py

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

refresh: refresh-base-fabric refresh-lite-fabric

update: update-base-fabric refresh-lite-fabric

export: export-base-fabric export-lite-fabric
