return {
	{
		selectorStack = {
			{
				object = "Part",
				classes = {
					"Red"
				}
			}
		},
		properties = {
			BrickColor = BrickColor.new(1, 0, 0)
		}
	},
	{
		selectorStack = {
			{
				object = "ClickDetector",
				id = "ClickMe"
			}
		},
		properties = {
			MaxActivationRadius = 13.5
		}
	},
	{
		selectorStack = {
			{
				object = "Model",
				id = "MyModel"
				classes = {
					"NiceModel"
				}
			}
		}
		properties = {
			Name = "Nice Model"
		}
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
		properties = {
			Name = "Grandchild"
		}
	}
}