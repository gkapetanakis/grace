(lang dune 3.11)
(using menhir 2.1)

(name grace)

(generate_opam_files true)

(authors "Dimitrios Georgousis" "Georgios-Alexios Kapetanakis")

(license "MIT")

(package
 (name grace)
 (synopsis "A compiler project for the NTUA Compilers course")
 (depends ocaml dune))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
