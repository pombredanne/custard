class Cu.View.SignUp extends Backbone.View
  className: 'sign-up'
  events:
    'click #go': 'go'
    'keyup #displayName': 'keyupDisplayName'
    'keyup #shortName': 'keyupShortName'
    'blur #shortName': 'keyupDisplayName'

  render: ->
    @el.innerHTML = JST['sign-up']()

  go: (e) ->
    e.preventDefault()
    $('#go', @$el).addClass('loading').html('Creating Account&hellip;')

    @cleanUpForm()

    model = new Cu.Model.User

    model.save
      shortName: $('#shortName').val()
      email: $('#email').val()
      displayName: $('#displayName').val()
      inviteCode: $('#inviteCode').val()
    ,
      success: (model, response, options) ->
        console.log model, response, options
        $('form').hide()
        $('#thanks').show()
      error: (model, response, options) =>
        $('#go', @$el).removeClass('loading').html('Go!')

        console.warn model, response, options
        if response.responseText
          # Probably an xhr object.
          xhr = response
          jsonResponse = JSON.parse xhr.responseText
          $div = $("""<div class="alert alert-error" id="hghg"><strong>#{jsonResponse.error or "Something went wrong"}<strong></div>""")
          #TODO: don't prepend, as we end up with multiple alerts
          @$el.prepend $div
          if jsonResponse.code == 'username-duplicate'
            # :todo: Add password reset link.
            $div.append(""" Is that you? If we had a password reset link, we'd give it to you now.""")
          else
            # Don't really know what the error is, so say something technical and geeky.
            $div.append("""<code>#{JSON.stringify jsonResponse}</code>""")
        else
          # probably a thing returned by the model validate method.
          $('#go', @$el).removeClass('loading').html('<i class="icon-ok space"></i> Create Account')
          for key of response
            $("##{key}").after("""<span class="help-inline">#{response[key]}</span>""").parents('.control-group').addClass('error')

  cleanUpForm: ->
    $('.control-group.error', @$el).removeClass('error').find('.help-inline').remove()

  keyupShortName: (e) ->
    if $(e.target).val() == ''
      $(e.target).removeClass('edited')
    else
      $(e.target).addClass('edited')

  keyupDisplayName: ->
    # "is" is a reserved word in coffeescript, so we use
    # long form method notation for the .is() jQuery function!!
    if not $('#shortName')['is']('.edited')
      username = $('#displayName').val()
      username = username.toLowerCase().replace(/[^a-zA-Z0-9-.]/g, '')
      $('#shortName').val(username)