local Table

if game
	Table = require(plugin.com.blacksheepherd.util.Table)
else
	Table = require "com.blacksheepherd.util.Table"

class BinaryHeap
	Insert: (el) =>
		table.insert self, el
		@\_upheap(#self)

	IsEmpty: =>
		#self == 0

	_upheap: (i) =>
		el = self[i]
		parentI = @\_parentI(i)
		
		unless parentI == nil
			parentEl = self[parentI]

			if el > parentEl
				Table.Swap(self, i, parentI)

	_downheap: (i) =>


	_parentI: (i) =>
		return unless i == 1
			math.floor(i / 2)
		else
			nil

	_leftChildI: (i) => self[2 * i]

	_rightChildI: (i) => self[2 * i + 1]