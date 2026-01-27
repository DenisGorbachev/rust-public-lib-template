# Concepts for knowledge base

## Observer

A program that downloads [informal knowledge](#informal-knowledge) from external knowledge sources and writes it into a local directory.

Requirements:

* Must accept a `dir` as the last positional parameter (the target local directory)
* Must atomically replace the old directory with a new directory
  * Create the temp directory in the same parent directory as `dir` (suffix: ".new") (same filesystem required for atomic rename)
  * Build the new contents fully inside the temp directory
  * Fsync files and the temp directory (best-effort where supported)
  * If `dir` exists, rename it to a backup name in the same parent directory (suffix: ".old")
  * Rename the temp directory to `dir` (atomic on POSIX and Windows when same filesystem)
  * If the final rename fails, attempt to restore the backup and keep the temp directory for debugging
  * After a successful replace, remove the backup directory

## Informal knowledge

A set of byte arrays that represents the knowledge about an external system.

Examples:

* [Polymarket docs](https://docs.polymarket.com/)

Notes:

* Some informal knowledge may be formatted as Markdown (example: a technical documentation page).
* Some informal knowledge may be formatted as images (example: a diagram).
* Some informal knowledge may be formatted as PDF (example: a device manual).
* Some informal knowledge may contain contradictions.
* Some informal knowledge may contradict the experimental knowledge.
* This kind of knowledge is called "informal" because it doesn't have a unique representation in any formal language.
  * Informal knowledge has multiple potential representations in any formal language.
  * Informal knowledge is inherently ambiguous (see: [disambiguation](#disambiguation)).

## Formal knowledge

A set of declarations in a specific formal language.

Notes:

* Most common language: Lean 4.

## Experimental knowledge

A [formal knowledge](#formal-knowledge) that has been obtained through a formally defined experiment.

Examples:

* Uniqueness of a value within a dataset.

## Disambiguation

A process whose input is [informal knowledge](#informal-knowledge) and output is [formal knowledge](#formal-knowledge) that doesn't have internal contradictions.

Note:

* A single informal knowledge base may be related to multiple formal knowledge bases without internal contradictions ("multiple coherent interpretations of reality").
