$(document).on 'ready page:load', ->
  $('pre > code').each ->
    copy_button = $ '<div class="btn btn-default btn-xs code-copy-button">Copy <span class="glyphicon glyphicon-copy"></span></div>'
    copy_button.attr 'data-code-copy-button': 'true'

    Tipped.create copy_button, 'Copy snippet to clipboard'

    $(this).parent().prepend copy_button

  new Clipboard '[data-code-copy-button]',
    text: (button) ->
      $(button).siblings('code')[0].textContent