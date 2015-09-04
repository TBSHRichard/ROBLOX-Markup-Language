HashMap = require("net.blacksheepherd.util.HashMap")

return {
	{
		"object",
		"ScreenGui",
		nil,
		nil,
		nil,
		{
			{
				"for",
				"_, message in pairs(messages)",
				{
					"messages"
				},
				{
					{
						"object",
						"TextLabel",
						nil,
						nil,
						HashMap({
							Text = "message.name"
						}),
						{}
					},
					{
						"object",
						"TextLabel",
						nil,
						nil,
						HashMap({
							Text = "message.body"
						}),
						{}
					},
					{
						"if",
						"message.author == \"Admin\"",
						{},
						{
							{
								"object",
								"ImageLabel",
								nil,
								nil,
								HashMap({
									Image = "\"rbxassetid://0\""
								}),
								{}
							}
						},
						{}
					}
				}
			}
		}
	}
}