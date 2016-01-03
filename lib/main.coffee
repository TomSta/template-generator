
CSON = require 'season'

TemplateSelectorDialog = null

module.exports = TemplateGenerator =
  config:
    templatesFilePath:
      type:'string'
      default:"#{atom.packages.resolvePackagePath('template-generator')}\\templates.cson"
      title:'Templates File'
      description:'Templates File to store all the Templates data'


  activate: ( state ) ->

    # Register command for views
    atom.commands.add 'atom-workspace', 'template-generator:toggle-settings-view': =>
      @createSettingsView().toggle()
    atom.commands.add '.tree-view', 'template-generator:toggle-template-generator': =>
      @toggleTemplateSelectorDialog()

  createSettingsView: ->
    unless @maSettingsView?
      SettingsView = require './template-generator-bottom-panel'
      @maSettingsView = new SettingsView()

    @maSettingsView

  createTemplateSelectorDialog: ( args ) ->
    unless @maTemplateSelectorDialog?
      TemplateSelectorDialog ?= require './template-generator-template-selector-dialog'
      @maTemplateSelectorDialog = new TemplateSelectorDialog( args )

    @maTemplateSelectorDialog

  toggleTemplateSelectorDialog: ->
    pkgTreeView = atom.packages.getActivePackage('tree-view')
    selectedEntry = pkgTreeView.mainModule.treeView.selectedEntry() ? pkgTreeView.mainModule.treeView.roots[0]
    selectedPath = selectedEntry?.getPath() ? ''

    configFilePath = atom.config.get('template-generator.templatesFilePath')
    CSON.readFile configFilePath, ( err, json ) =>
        if json?
          dialog = @createTemplateSelectorDialog( {selectedPath} )
          dialog.setItems( json )
          dialog.attach()

  deactivate: ->

  serialize: ->