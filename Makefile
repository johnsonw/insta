all: test

build:
	@cargo build --all-features

doc:
	@RUSTC_BOOTSTRAP=1 RUSTDOCFLAGS="--cfg=docsrs" cargo doc --no-deps --all-features

test: cargotest

cargotest:
	@echo "CARGO TESTS"
	@rustup component add rustfmt 2> /dev/null
	@cargo test
	@cargo test --all-features
	@cargo test --no-default-features
	@cargo test --features redactions -- --test-threads 1
	@echo "CARGO-INSTA TESTS"
	# Turn off CI flag so that cargo insta test behaves as we expect
	# under normal operation
	@CI=0 cargo test -p cargo-insta

check-minver:
	@echo "MINVER CHECK"
	@cargo minimal-versions check
	@cargo minimal-versions check --all-features
	@cargo minimal-versions check --no-default-features
	@cargo minimal-versions check --features redactions

format:
	@rustup component add rustfmt 2> /dev/null
	@cargo fmt --all

format-check:
	@rustup component add rustfmt 2> /dev/null
	@cargo fmt --all -- --check

lint:
	@rustup component add clippy 2> /dev/null
	@cargo clippy --all-targets --workspace -- --deny warnings

.PHONY: all doc test cargotest format format-check lint update-readme
