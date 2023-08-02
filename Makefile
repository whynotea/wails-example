.PHONY: default
default: all

.PHONY: all
all:
	goreleaser build --single-target --snapshot --clean

build-%: 
	goreleaser build --single-target --snapshot --clean --id $*

release:
	goreleaser --verbose release --snapshot --clean --skip-sbom --skip-sign --skip-publish --skip-validate
	find ./cmd -name '*.syso' | xargs -I file rm file

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
