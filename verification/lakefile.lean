import Lake
open Lake DSL

package «assay-proofs» where
  leanOptions := #[⟨`autoImplicit, false⟩]

@[default_target]
lean_lib AssayProofs

@[default_target]
lean_exe sourceModel where
  root := `Main
