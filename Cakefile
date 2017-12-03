fs            = require 'fs'
{ execSync }  = require 'child_process'
luamin        = require 'luamin'

cwd = __dirname.replace /\\/g, '/'
templateNames = [ 'romllib' ]
build         = 'build'
tmpFile       = 'tmp.moon'

task 'build', 'Build the templates into a single, minified Lua script.', ->
  timeTask ->
    for templateName in templateNames
      console.log "Starting build for #{templateName}"
      buildTemplate("#{cwd}/src/#{templateName}.moon")
      console.log "#{templateName} finished building\n"

for templateName in templateNames
  task "build:#{templateName}", "Build the #{templateName} template into a single, minified Lua script.", ->
    timeTask ->
      buildTemplate("#{cwd}/src/#{templateName}.moon")

timeTask = (taskFn) ->
  startTime = new Date().getTime()
  taskFn()
  endTime = new Date().getTime()
  console.log "\nBuild completed in #{endTime - startTime}ms!"

buildTemplate = (templateLocation) ->
  script = loadTemplate(templateLocation)
  console.log 'Loaded template.'

  script = fillTemplate(script)
  console.log 'Template filled out.'

  writeMoonScriptToTemporaryFile(script)
  console.log "Wrote MoonScript to temporary file: #{tmpFile}."

  script = compileMoonScript().toString()
  console.log "Compiled temporary MoonScript file."

  script = minifyLuaScript(script)
  console.log 'Minified output lua script.'

  createOutputDirectoryIfItDoesNotExist()

  outFile = getOutputFilename(templateLocation) + '.lua'

  writeLuaScriptToOutputDirectory(script, outFile)
  console.log "Wrote lua script to file: #{build}/#{outFile}."

  removeTemporaryMoonScriptFile()
  console.log 'Removed temporary MoonScript file.'

loadTemplate = (templateLocation) ->
  buffer = fs.readFileSync templateLocation
  return replaceLineEndings buffer.toString()

replaceLineEndings = (code) ->
  code = code.replace /\r\n/g, '\n'
  return code.replace /\r/g, '\n'

fillTemplate = (template) ->
  importPattern = /--\s*{{\s*TBSHTEMPLATE:IMPORT\s+([^\s]*)\s*}}/gi
  return template.replace importPattern, (match, location) ->
    buffer = fs.readFileSync "#{cwd}/src/#{location}"
    code = replaceLineEndings buffer.toString()
    return extractSpecifiedCodeBlock code

extractSpecifiedCodeBlock = (fileContents) ->
  specifiedCodeBlockPattern = /--\s*{{\s*TBSHTEMPLATE\s*:\s*BEGIN\s*}}\n([\w\W]*)\n--\s*{{\s*TBSHTEMPLATE\s*:\s*END\s*}}/gi
  match = specifiedCodeBlockPattern.exec(fileContents)

  if match == null
    return ''

  return match[1]

writeMoonScriptToTemporaryFile = (script) ->
  fs.writeFileSync tmpFile, script

compileMoonScript = ->
  execSync "moonc -p #{tmpFile}"

minifyLuaScript = (script) ->
  luamin.minify script

createOutputDirectoryIfItDoesNotExist = ->
  if !fs.existsSync build
    fs.mkdirSync build
    console.log "Created output directory: ./#{build}"

getOutputFilename = (templateLocation) ->
  lastSlashIndex = templateLocation.lastIndexOf '/'
  templateName = templateLocation.substring lastSlashIndex + 1
  extensionIndex = templateName.indexOf '.'
  return templateName.substring 0, extensionIndex

writeLuaScriptToOutputDirectory = (script, outFile) ->
  fs.writeFileSync "#{build}/#{outFile}", script

removeTemporaryMoonScriptFile = ->
  fs.unlinkSync tmpFile
