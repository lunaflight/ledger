let cmd =
  let check src () =
    let owes_list = Tracker.get_owees_of (Saver.load_tracker ()) src in
    let print (user, money) =
      match money with
      | x when Money.is_pos x ->
        Printf.printf
          "%s owes %s %s\n"
          (Person.to_string src)
          (Person.to_string user)
          (Money.to_abs_string money)
      | x when Money.is_neg x ->
        Printf.printf
          "%s paid %s %s\n"
          (Person.to_string src)
          (Person.to_string user)
          (Money.to_abs_string money)
      | _ -> failwith "$0 should not be recorded in the tracker\n."
    in
    List.iter print owes_list
  in
  Command.basic
    ~summary:"Check how much money [user] has."
    (let%map_open.Command user = anon ("user" %: string) in
     check (Person.of_name user))
;;
