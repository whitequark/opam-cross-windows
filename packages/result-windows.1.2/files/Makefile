.PHONY: all
all: byte native result.install

result.ml: which_result.ml
	cp `ocaml which_result.ml` result.ml

.PHONY: byte
byte: result.ml
	ocamlfind ocamlc -c result.ml
	ocamlfind ocamlc -a -o result.cma result.cmo

.PHONY: native
native: result.ml
	ocamlfind ocamlopt -c result.ml
	ocamlfind ocamlopt -a -o result.cmxa result.cmx
	ocamlfind ocamlopt -shared -linkall -o result.cmxs result.cmxa || true

result.install: result.cma gen_result_install.ml
	ocaml gen_result_install.ml

.PHONY: install
install:
	ocamlfind remove result 2> /dev/null || true
	ocamlfind install result META result.*

.PHONY: uninstall
uninstall:
	ocamlfind remove result

.PHONY: clean
clean:
	rm -f result.*
