# Ledger

This is a pet project made for fun in OCaml.

It helps to keep track of the amount of money that is circulated among a circle
of friends.

## Installation

You first need OCaml and [Dune](https://dune.build/install) to run this project.
1. Clone this repository with `git clone`.
2. Run `dune build` to build the project and install the required dependencies.

## Usage

The main command of entry of the project is as follows:
```sh
dune exec -- ./bin/main.exe
```

Execute the above and you will get a summary of available subcommands.

### Commands

`add user`
Adds a user to the tracker.

`check user`
Prints how much money the user has paid or owes.

`delete user`
Deletes a user from the tracker.

`transfer src dst money`
Transfers the amount of money from the src user to the dst user.

Money must be of the form: Optionally a `$`, followed by some number of digits for dollars, and possibly ending with a `.` and 2 digits for cents.

## Development

```sh
dune runtest
```
This executes all the files with `.ml` residing in the `test` directory to
check the correctness of the program.
