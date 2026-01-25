# CLI for type concepts

## Target type

The type that the CLI is being implemented for.

Example:

```rust
//! In this example, all types are in the same file. In real code, the types must be in their own files according to project guidelines

use FooSubcommand::*;
use errgonomic::map_err;
use thiserror::Error;

pub struct FooClient {
    api_key: String
}

pub struct User {
    id: u64,
    name: String
}

impl FooClient {
    pub fn users(&self, _page: u64) -> Result<Vec<User>, FooClientUsersError> {
        todo!()
    }

    pub fn set_user_name(&self, id: u64, name: &str) -> Result<Vec<User>, FooClientSetUserNameError> {
        todo!()
    }
}

#[derive(Error, Debug)]
pub enum FooClientUsersError {
    // TODO
}

#[derive(Error, Debug)]
pub enum FooClientSetUserNameError {
    // TODO
}

#[derive(clap::Parser, Debug)]
#[command(author, version, about, propagate_version = true)]
pub struct FooCommand {
    #[command(subcommand)]
    subcommand: FooSubcommand,
}

#[derive(clap::Subcommand, Clone, Debug)]
pub enum FooSubcommand {
    Users(UsersCommand),
}

impl FooCommand {
    pub async fn run(self) -> Result<(), FooCommandRunError> {
        use FooCommandRunError::*;
        let Self {
            subcommand,
        } = self;
        match subcommand {
            Users(command) => map_err!(command.run().await, UsersCommandRunFailed),
        }
    }
}

#[derive(Error, Debug)]
pub enum FooCommandRunError {
    #[error("failed to run users command")]
    UsersCommandRunFailed { source: UsersCommandRunError },
}

```

## Parent command

The command that implements the CLI for the type.

Requirements:

* Must construct the [target type](#target-type) and pass it to [child commands](#child-command)

## Child command

The subcommand of the [parent command](#parent-command) that implements a CLI for the method of the type.

Requirements:

* Must have a field for each argument of the method of the type.
