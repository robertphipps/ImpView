control = window.control

onReadys = control.onReadys

activeElement = null
activeHandlers = []

addKeyboardHandlers = ->
  body$ = $('body')

  # Escape Handler
  body$.on 'keydown', (e) ->
    if e.keyCode == 27
      $('#quick-hide-all').click()
    else if e.keyCode == 192
      $('#quick-fade-all').click()

  $('.control-group[data-shortcut]').each (i, item) ->
    item$ = $(item)
    shortcut = item$.data('shortcut')
    keycode = shortcut.toString().charCodeAt(0)

    body$.on 'keydown', (e) ->
      return unless e.keyCode == keycode

      # Remove the old active element
      activeElement.removeClass('active') if activeElement != null

      activeElement = item$
      activeElement.addClass('active')
      oldHandlers = activeHandlers
      activeHandlers = []

      body$.animate
          scrollTop: item$.offset().top - 30 + 'px'
        , 'fast'

      children = item$.find('*[data-shortcut]')
      children.each (i, child) ->
        child$ = $(child)
        cshortcut = child$.data('shortcut')
        ckeycode = cshortcut.toString().toUpperCase().charCodeAt(0)

        #An oddity... for some reason chrome converts these incorrectly.
        if ckeycode == 92
          # Backslash
          ckeycode = 220
        if ckeycode == 47
          # Forward Slash
          ckeycode = 191
        if ckeycode == 44
          # Comma
          ckeycode = 188
        if ckeycode == 46
          # Period
          ckeycode = 190

        handler = (e) ->
          return unless e.keyCode == ckeycode

          child$.click()

        body$.on 'keydown', handler
        activeHandlers.push handler

      $.each oldHandlers, (i, handler) ->
        body$.off('keydown', handler)
        return
      return
    return

onReadys.push ->
  body$ = $('body')

  addKeyboardHandlers()

  $('.disable-shortcuts').each (i, item) ->
    item$ = $(item)

    item$.focus ->
      body$.off('keydown')
      return

    item$.blur ->
      addKeyboardHandlers()

      $.each activeHandlers, (i, handler) ->
        body$.on('keydown', handler)

      return

    return

  return