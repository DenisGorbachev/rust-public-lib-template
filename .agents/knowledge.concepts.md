# Concepts for knowledge base

## Observer

A program that downloads [informal knowledge](#informal-knowledge) from [source](#informal-knowledge-source) and writes it into a local directory.

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

A directory that represents the knowledge about an external system.

Notes:

* Some informal knowledge may be formatted as Markdown (example: a technical documentation page).
* Some informal knowledge may be formatted as images (example: a diagram).
* Some informal knowledge may be formatted as PDF (example: a device manual).
* Some informal knowledge may contain contradictions.
* Some informal knowledge may contradict the experimental knowledge.
* This kind of knowledge is called "informal" because it doesn't have a unique representation in any formal language.
  * Informal knowledge has multiple potential representations in any formal language.
  * Informal knowledge is inherently ambiguous (see: [disambiguation](#disambiguation)).
* Some informal knowledge files have an internal tree structure
  * Examples
    * Every valid source code file has an internal tree structure
    * Every valid Markdown file has an internal tree structure
* Some informal knowledge files may have [divergent content and extension](#divergent-file-content-and-file-extension-for-a-specific-validator-map)

## Informal knowledge source

A string that uniquely identifies a subset of informal knowledge.

Examples:

* Polymarket docs: <https://docs.polymarket.com/>
* Polymarket CTF exchange contract source code: <https://github.com/Polymarket/ctf-exchange>
* Polymarket CTF exchange contract instance: <https://polygonscan.com/address/0x4bfb41d5b3570defd03c39a9a4d8de6bd8b8982e>

Notes:

* The examples are a map from a source name to a source value.

## Informal knowledge reference

TODO

Requirements:

* Must be a hash of content:
  * Reasons:
    * The [observer](#observer) may return different content each time
      * Some content may be modified by external actors that have write permissions on [source](#informal-knowledge-source)
      * Some content may be modified as a result of external API calls
        * Examples:
          * The list of trades may be extended due to new orders being placed and matched.

## Formal knowledge

A set of declarations in a specific formal language.

Requirements:

* Every declaration must contain a [reference](#informal-knowledge-reference) to a specific element of the informal knowledge

Preferences:

* Declaration A is better than Declaration B if Declaration A [reference](#informal-knowledge-reference) is more precise than Declaration B [reference](#informal-knowledge-reference) and other properties are equal.

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

## Reference A is more precise than Reference B

Reference A is more precise than Reference B if Reference A is a child of Reference B.

Examples:

* Given a source code file `s`, a reference to a specific method within `s` is more precise than reference to `s` itself.

## Divergent file content and file extension for a specific validator map

File content and file extension are divergent for a specific map from file extensions to file content validators and a path to the file iff the file content doesn't pass the validator implied by the file extension.
