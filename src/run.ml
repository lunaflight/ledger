let transfer =
  let transfer money src dst () =
    let tracker = Saver.load_tracker () in
    let tracker = Tracker.transfer tracker src dst money in
    Saver.save_tracker tracker
  in
  Command.basic
    ~summary:"Transfer [money] from [src] to [dst]."
    (let%map_open.Command src = anon ("src" %: string)
     and dst = anon ("dst" %: string)
     and money = anon ("money" %: int) in
     transfer (Money.of_cents money) (Person.of_name src) (Person.of_name dst))
;;

let check =
  let check src () =
    let owes_list = Tracker.get_owees_of (Saver.load_tracker ()) src in
    let print (person, money) =
      match money with
      | x when Money.is_pos x ->
        Printf.printf
          "%s owes %s %s\n"
          (Person.to_string src)
          (Person.to_string person)
          (Money.to_abs_string money)
      | x when Money.is_neg x ->
        Printf.printf
          "%s paid %s %s\n"
          (Person.to_string src)
          (Person.to_string person)
          (Money.to_abs_string money)
      | _ -> failwith "$0 should not be recorded in the tracker\n."
    in
    List.iter print owes_list
  in
  Command.basic
    ~summary:"Check how much money [person] has."
    (let%map_open.Command person = anon ("person" %: string) in
     check (Person.of_name person))
;;

let add =
  let add user () =
    let tracker = Saver.load_tracker () in
    let tracker = Tracker.add tracker user in
    Saver.save_tracker tracker
  in
  Command.basic
    ~summary:"Add [user] to the tracker."
    (let%map_open.Command user = anon ("user" %: string) in
     add (Person.of_name user))
;;

let delete =
  let delete user () =
    let tracker = Saver.load_tracker () in
    let tracker = Tracker.delete tracker user in
    Saver.save_tracker tracker
  in
  Command.basic
    ~summary:"Delete [user] from the tracker."
    (let%map_open.Command user = anon ("user" %: string) in
     delete (Person.of_name user))
;;

let reset =
  let reset is_confirmed () =
    if is_confirmed
    then Saver.delete_tracker ()
    else (
      Printf.printf "Delete the tracker? [y/N]: ";
      Out_channel.flush stdout;
      match In_channel.(input_line stdin) with
      | Some x when x = "y" -> Saver.delete_tracker ()
      | _ -> Printf.printf "Operation aborted.\n")
  in
  Command.basic
    ~summary:"Delete all information from the tracker."
    (let%map_open.Command is_confirmed =
       flag "-yes" no_arg ~doc:"Delete without prompting"
     in
     reset is_confirmed)
;;

let command =
  Command.group
    ~summary:"A simple command line interface to track money."
    [ "add", add; "check", check; "delete", delete; "reset", reset; "transfer", transfer ]
;;

let main () = Command_unix.run ~version:"1.0" ~build_info:"MoneyApp" command
