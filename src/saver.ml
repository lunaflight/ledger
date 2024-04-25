open! Core
open! Sexplib.Std

let save_tracker ?(filename="data/tracker.sexp") tracker =
    let outc = Out_channel.create filename in
    Out_channel.fprintf outc "%s" (Tracker.to_string tracker);
    Out_channel.close outc

let load_tracker ?(filename="data/tracker.sexp") () =
    try
        let inc = In_channel.create filename in
        let tracker = Tracker.of_string @@ In_channel.read_all filename in
        In_channel.close inc;
        tracker
    with
    | Sys_error _ -> Tracker.empty
