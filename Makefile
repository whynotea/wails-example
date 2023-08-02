.PHONY: default
default: all

.PHONY: all
all:
	goreleaser build --single-target --snapshot --clean

build-%: 
	goreleaser build --single-target --snapshot --clean --id $*

release:
	goreleaser release --snapshot --clean --skip-sbom --skip-sign

.PHONY: run-%
run-%:
	@./dist/wails-example_linux_amd64_v1/wails-example $*

mv-tag-%:
	git push origin :refs/tags/$*
	git tag -fa $*
	git push origin $*

.PHONY: clean
clean:
	rm -rf ./dist

.PHONY: modules
modules:
	go mod tidy
