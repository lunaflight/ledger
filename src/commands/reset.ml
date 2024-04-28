let cmd =
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
