type assignment = NotAssigned | AssignedTrue | AssignedFalse

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
          merge vars clauses ((c, NotAssigned)::clause) tl

let rec add vars clauses =
  let () = print_string "add a clause: " in
  let raw_clause = read_line ()
  in
    if String.length raw_clause = 0 then (vars, List.rev clauses)
    else let clause = Str.split (Str.regexp " ") raw_clause in
      let (vars, clauses) = merge vars clauses [] clause in
      add vars clauses

let rec satisfiable clauses =
  match clauses with
    | [] -> true
    | hd :: tl ->
      if List.exists (fun (t,asmt) -> (asmt = AssignedTrue || asmt = NotAssigned)) hd then satisfiable tl
      else false

let t_asmt_map tindex t asmt v =
  if t/2 = tindex then
    (if t land 1 = 1 then
      (if v = true then AssignedFalse
      else AssignedTrue)
    else
      (if v = true then AssignedTrue
      else AssignedFalse)
    )
  else asmt

let rec assign_var tindex v clauses clauses' =
  match clauses with
    | [] -> List.rev clauses'
    | hd::tl -> assign_var tindex v tl ((List.map (fun (t,asmt) -> (t,t_asmt_map tindex t asmt v)) hd)::clauses')

let rec assign vars clauses assignments =
  match vars with
    | [] -> (satisfiable clauses, assignments)
    | (t,tindex) :: tl ->
      let true_assign = (assign_var tindex true clauses []) in
        let true_res = satisfiable true_assign in
          if true_res then let (dfs_res, assignment') = assign tl true_assign ((t,true)::assignments) in
            if dfs_res then (true, assignment')
            else let false_assign = (assign_var tindex false clauses []) in
                   let false_res = satisfiable false_assign in
                     if false_res then assign tl false_assign ((t,false)::assignments)
                     else (false, assignments)
          else let false_assign = (assign_var tindex false clauses []) in
            let false_res = satisfiable false_assign in
              if false_res then assign tl false_assign ((t,false)::assignments)
              else (false, assignments)

let rec sat () =
  let (vars, clauses) = add [] [] in
    assign vars clauses []
