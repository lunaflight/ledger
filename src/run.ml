let command =
  Command.group
    ~summary:"A simple command line interface to track money."
    [ "add", Commands.Add.cmd
    ; "check", Commands.Check.cmd
    ; "delete", Commands.Delete.cmd
    ; "reset", Commands.Reset.cmd
    ; "transfer", Commands.Transfer.cmd
    ]
;;

let main () = Command_unix.run ~version:"1.0" ~build_info:"MoneyApp" command
