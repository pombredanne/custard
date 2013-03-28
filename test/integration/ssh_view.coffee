should = require 'should'
{wd40, browser, login_url, home_url, prepIntegration} = require './helper'

describe 'View SSH Details', ->
  prepIntegration()

  before (done) ->
    wd40.fill '#username', 'ehg', ->
      wd40.fill '#password', 'testing', -> wd40.click '#login', done

  context 'when I click on an Prune dataset', ->
    before (done) ->
      # wait for tiles to fade in
      setTimeout ->
        browser.elementByPartialLinkText 'Prune', (err, link) ->
          link.click done
      , 500

    context 'when I click the "SSH in" menu link', ->
      before (done) ->
        browser.elementByCss '.view.tile .dropdown-toggle', (err, settingsLink) =>
          settingsLink.click =>
            wd40.click '.view.tile .git-ssh', done

      it 'a modal window appears', (done) =>
        wd40.getText '.modal', (err, text) =>
          @modalTextContent = text.toLowerCase()
          done()

      it 'the modal window asks for my SSH key', =>
        @modalTextContent.should.include 'add your ssh key:'

      it 'the modal tells me the command I should run', =>
        @modalTextContent.should.include 'ssh-keygen'

      context 'when I paste my ssh key into the box and press submit', ->
        before (done) ->
          wd40.fill '#ssh-key', 'ssh-rsa AAAAB3Nza...ezneI9HWBOzHnh foo@bar.local', ->
            wd40.click '#add-ssh-key', done

        before (done) =>
          wd40.getText '.modal', (err, text) =>
            @modalTextContent = text.toLowerCase()
            done()

        it 'the modal title says "ssh into your Graph of Prunes view"', =>
          @modalTextContent.should.include 'graph of prunes view'

        it 'the modal window no longer asks for my SSH key', =>
          @modalTextContent.should.not.include 'add your ssh key:'

        it 'the modal window tells me how to SSH in', =>
          @modalTextContent.should.include 'ssh 4008115731@box.scraperwiki.com'

        context 'when I close the modal, and reopen it', ->
          before (done) =>
            wd40.click '#done', =>
              setTimeout =>
                browser.elementByCss '.view.tile .dropdown-toggle', (err, settingsLink) =>
                  settingsLink.click =>
                    wd40.click '.view.tile .git-ssh', =>
                      wd40.getText '.modal', (err, text) =>
                        @modalTextContent = text.toLowerCase()
                        done()
              , 400

          it 'the modal window does not ask for my SSH key', =>
            @modalTextContent.should.not.include 'add your ssh key:'

          it 'the modal window tells me how to SSH in', =>
            @modalTextContent.should.include 'ssh 4008115731@box.scraperwiki.com'
