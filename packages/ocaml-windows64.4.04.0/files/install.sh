#!/bin/sh -e

PREFIX="$1"

for bin in ocamlc ocamlopt ocamlcp ocamlmklib ocamlmktop ocamldoc ocamldep; do
  cat >"${PREFIX}/windows-sysroot/bin/${bin}" <<END
#!/bin/sh
${PREFIX}/bin/ocamlrun "${PREFIX}/windows-sysroot/bin/${bin}.exe" "\$@"
END
  chmod +x "${PREFIX}/windows-sysroot/bin/${bin}"
done

for pkg in bigarray bytes compiler-libs dynlink findlib graphics num num-top stdlib str threads unix; do
  cp -r "${PREFIX}/lib/${pkg}" "${PREFIX}/windows-sysroot/lib/"
done
