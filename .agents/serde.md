# Guidelines for `serde`

* Every `Option`-wrapped field must have attributes:
  * `#[serde(skip_serializing_if = "Option::is_none")]`
* Every `OffsetDateTime` field must have attributes:
  * `#[serde(with = "time::serde::rfc3339")]`
* Every `Option<OffsetDateTime>` field must have attributes:
  * `#[serde(with = "time::serde::rfc3339::option")]`
