should = require 'should'
{wd40, browser, login_url, home_url, prepIntegration} = require './helper'

describe 'Pricing', ->
  prepIntegration()

  before (done) ->
    browser.get home_url + '/pricing', done

  before (done) =>
    wd40.getText 'body', (err, text) =>
      @bodyText = text
      # console.log text
      done()

  xit 'shows me a free "community" plan', =>
    @bodyText.toLowerCase().should.include 'community'

  it 'shows me a cheap "explorer" plan', =>
    @bodyText.toLowerCase().should.include 'explorer'

  it 'shows me an expensive "data scientist" plan', =>
    @bodyText.toLowerCase().should.include 'data scientist'

  it 'mentions our special corporate plans', =>
    @bodyText.toLowerCase().should.include 'corporate plans'

  context 'when I click the "explorer" plan', ->
    before (done) ->
      browser.elementByCssIfExists '.plan.explorer', (err, free) ->
        free.click done

    it 'takes me to the sign up page', (done) ->
      wd40.trueURL (err, url) ->
        url.should.include '/signup/explorer'
        done()
