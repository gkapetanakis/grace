(lang dune 3.11)
(using menhir 2.1)

(name grace)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Dimitrios Georgousis" "Georgios-Alexios Kapetanakis")

(maintainers "")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name grace)
 (synopsis "A compiler project for NTUA Compilers course")
 (description "A compiler project for NTUA Compilers course. We build a compiler for the 'Grace' programming language using OCaml and related tools.")
 (depends ocaml dune)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
