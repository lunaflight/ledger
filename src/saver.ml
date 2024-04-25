open! Core
open! Sexplib.Std

let save_tracker tracker = Tracker.sexp_of_t tracker
