HashMap = require("com.blacksheepherd.util.HashMap")

return {
	{
		selectorStack = {
			{
				id = "MyRedPart"
			},
			{
				object = "Model"
			}
		},
		properties = HashMap({
			BrickColor = "255, 0, 0"
		})
	},
	{
		selectorStack = {
			{
				object = "ClickDetector",
				class = "ClickMe"
			},
			{
				object = "Part"
			}
		},
		properties = HashMap({
			MaxActivationRadius = "13.5"
		})
	},
	{
		selectorStack = {
			{
				object = "Part"
			},
			{
				object = "Model"
			},
			{
				object = "Model"
			}
		},
		properties = HashMap({
			Name = "\"Grandchild\""
		})
	}
}