should = require 'should'
{wd40, browser, base_url, login_url, home_url, prepIntegration} = require './helper'

describe 'Free Trial', ->
  prepIntegration()

  context 'when I log in as a free trial user', ->
    before (done) ->
      wd40.fill '#username', 'free-trial-user', ->
        wd40.fill '#password', 'testing', ->
          wd40.click '#login', done

    before (done) ->
      browser.waitForElementByCss '.dataset-list', 4000, done

    it 'should tell me "14 days left"', (done) ->
      wd40.getText '.trial a', (err, text) ->
        text.toLowerCase().should.include '14 days left'
        done()

    context 'when I click on the "Free Trial" message', ->
      before (done) ->
        wd40.click '.trial a', done

      it 'should be on the pricing page', (done) ->
        wd40.trueURL (err, url) ->
          url.should.equal "#{base_url}/pricing"
          done()

    context 'when I click the super duper ScraperWiki digger', ->
      before (done) ->
        wd40.click '#logo', done

      it 'should be on the datasets page', (done) ->
        wd40.trueURL (err, url) ->
          url.should.equal "#{base_url}/datasets"
          done()

describe 'Expired Free Trial', ->
  prepIntegration()

  context 'when I log in as an expired free trial user', ->
    before (done) ->
      wd40.fill '#username', 'expired-user', ->
        wd40.fill '#password', 'testing', ->
          wd40.click '#login', done

    it 'I am redirected to the pricing page', ->
      wd40.trueURL (err, url) ->
        url.should.equal "#{base_url}/pricing/expired"

    it 'should link to pricing expired page', (done) ->
      wd40.click '.trial a', (err, text) ->
        wd40.trueURL (err, url) ->
          url.should.equal "#{base_url}/pricing/expired"
          done()



describe 'Paid user', ->
  prepIntegration()

  context 'when I log in as a paying user', ->
    before (done) ->
      wd40.fill '#username', 'ehg', ->
        wd40.fill '#password', 'testing', ->
          wd40.click '#login', done

    before (done) ->
      browser.waitForElementByCss '.dataset-list', 4000, done

    it 'should not tell me "Free trial"', (done) ->
      wd40.getText 'body', (err, text) ->
        (/Free trial/i.test text).should.be.false
        done()

