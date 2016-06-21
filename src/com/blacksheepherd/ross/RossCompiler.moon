Array = require "com.blacksheepherd.util.Array"
Table = require "com.blacksheepherd.util.Table"
AnonymousTableBlock = require "com.blacksheepherd.code.AnonymousTableBlock"
StackBlock = require "com.blacksheepherd.code.StackBlock"
Line = require "com.blacksheepherd.code.Line"
MainRossBlock = require "com.blacksheepherd.code.MainRossBlock"
CompilerPropertyFilter = require "com.blacksheepherd.compile.CompilerPropertyFilter"

local mainBlock

calculateAndAddSpecificity = (block) ->
	numberOfObjects = 0
	numberOfClasses = 0
	numberOfIds = 0

	for selector in *block.selectorStack
		numberOfObjects += 1 unless selector["object"] == nil

		if selector["class"] != nil
			numberOfClasses += 1
		elseif selector["id"] != nil
			numberOfIds += 1

	block.specificity = numberOfIds * 2^16 + numberOfClasses * 2^8 + numberOfObjects

createAndAddSelectorBlock = (block) ->
	selectorBlock = AnonymousTableBlock!

	selectorStackBlock = StackBlock("selector")

	selectorTop = block.selectorStack[1]

	for selector in *block.selectorStack
		selectorStackItemBlock = AnonymousTableBlock!

		if selector.object != nil
			selectorStackItemBlock\AddChild Line("object = \"#{selector.object}\"")

		if selector.class != nil
			selectorStackItemBlock\AddChild Line("class = \"#{selector.class}\"")
		elseif selector.id != nil
			selectorStackItemBlock\AddChild Line("id = \"#{selector.id}\"")

		selectorStackBlock\AddChild selectorStackItemBlock

	keyName = ""
	className = ""

	if selectorTop.object != nil
		keyName = selectorTop.object
		className = selectorTop.object

	selectorBlock\AddChild selectorStackBlock

	if block.properties
		for name, value in block.properties\pairs!
			block.properties[name] = CompilerPropertyFilter.FilterProperty className, name, value

		selectorBlock\AddChild Line("properties = #{Table.HashMapToSingleLineString(block.properties)}")
	else
		selectorBlock\AddChild Line("properties = {}")

	if selectorTop.class != nil
		keyName ..= ".#{selectorTop.class}"
		mainBlock\AddClassSelector keyName, selectorBlock
	elseif selectorTop.id != nil
		keyName ..= "##{selectorTop.id}"
		mainBlock\AddIdSelector keyName, selectorBlock
	else
		mainBlock\AddObjectSelector keyName, selectorBlock

addCode = (tree) ->
	if tree
		tree = Array.StableSort tree, (left, right) ->
			calculateAndAddSpecificity(left) if left.specificity == nil
			calculateAndAddSpecificity(right) if right.specificity == nil

			left.specificity >= right.specificity

		for rossBlock in *tree
			createAndAddSelectorBlock rossBlock

Compile = (name, parseTree) ->
	mainBlock = MainRossBlock name

	addCode parseTree
	mainBlock\Render!

{ :Compile }