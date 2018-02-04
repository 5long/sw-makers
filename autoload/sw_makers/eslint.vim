fun! sw_makers#eslint#ProcessOutput(context) abort
  let [ errors, warnings ] = s:ParseLines(a:context.output)
  return empty(errors) ? warnings : errors
endf

fun! s:ParseLines(lines) abort
  let results = [[], []]
  let [ errors, warnings ] = results

  for line in a:lines
    let msg = s:ParseCompactLine(line)

    if !msg.valid
      continue
    endif

    call add(msg.type == 'W' ? warnings : errors, msg)
  endfor

  return results
endf

fun! s:ParseCompactLine(line)
  let end_of_parsed_text = 0
  let [fn, _, end_of_parsed_text] = matchstrpos(a:line, '^.*\ze: ')

  if empty(fn)
    return {'valid': v:false, 'text': a:line}
  endif

  let [line_number, _, end_of_parsed_text] = matchstrpos(a:line, 'line \zs\d\+\ze, ', end_of_parsed_text)
  let [column_number, _, end_of_parsed_text] = matchstrpos(a:line, 'col \zs\d\+\ze, ', end_of_parsed_text)
  let [msg_type, _, end_of_parsed_text] = matchstrpos(a:line, '\(Error\|Warning\) - ', end_of_parsed_text)
  let msg_type = msg_type[0]
  let msg_text = a:line[end_of_parsed_text:]

  return {
        \ 'maker_name': 'eslintsw',
        \ 'filename': fn,
        \ 'lnum': line_number,
        \ 'col': column_number,
        \ 'type': msg_type,
        \ 'text': msg_text,
        \ 'valid': v:true,
        \ }
endf
