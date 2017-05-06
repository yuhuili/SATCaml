let term x =
  if Str.string_match (Str.regexp "~") x 0 then
    Str.last_chars x ((String.length x)-1)
  else x

let get_term_index vars t =
  match List.filter (fun (x, y) -> x = t) vars with
    | [] -> let index = List.length vars in
      ((t, List.length vars)::vars, index)
    | (_, y) :: _ -> (vars, y)    

let rec merge vars clauses clause clause' =
  match clause' with
    | [] -> (vars, List.rev clause::clauses)
    | hd :: tl ->
      let t = (term hd) in
        let (vars, tindex) = get_term_index vars t in
          let c = if t = hd then (tindex * 2)
                  else (tindex * 2) + 1 in
          merge vars clauses (c::clause) tl

let rec add vars clauses =
  let () = print_string "add a clause: " in
  let raw_clause = read_line ()
  in
    if String.length raw_clause = 0 then List.rev clauses
    else let clause = Str.split (Str.regexp " ") raw_clause in
      let (vars, clauses) = merge vars clauses [] clause in
      add vars clauses
