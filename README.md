# SKIDED LOLLL
This documentation is for RedZ UI V2 Credit To REDZ

## Booting the SKIBIDI UI Library
```lua
loadstring(game:HttpGet(("https://raw.githubusercontent.com/rsdashman/pls-dont-click-here/refs/heads/main/Th4mKrsLibSource")))()
```

## skibidi 1 , 2 , 3


## Creating a SKIDED UI V2 UI Window
```lua
MakeWindow({
  Hub = {
    Title = "Th4mKrsLib",
    Animation = "by : skibidi edit from Redzhub"
  },
  Key = {
    KeySystem = false,
    Title = "Key System",
    Description = "",
    KeyLink = "",
    Keys = {"1234"},
    Notifi = {
      Notifications = true,
      CorrectKey = "Running the Script...",
      Incorrectkey = "The key is incorrect",
      CopyKeyLink = "Copied to Clipboard"
    }
  }
})

--[[
  Hub = {
    Title = "idk bro" -- <string> Title of your script
    Animation = "by : [u name]" -- <string> Add text to your HUB animation
  },
  Key = {
    KeySystem = <boolean> Adds a key system
    Title = "Key System" <string> Add a title to your key system
    Description = "" <string> Adds a description to your key system
    KeyLink = "" <string> Add the Link where you get the HUB key
    Keys = {"1234"} <table> Add the Keys
    Notifi = {
      Notifications = true <boolean> Add notifications to the key system
      CorrectKey = "Running the Script..." <string> notification when key is correct
      Incorrectkey = "The key is incorrect" <string> notification when key is incorrect
      CopyKeyLink = "Copied to Clipboard" <string> notification when key link is copied
    }
  }
]]
```

## MiniMize Button
```lua
MinimizeButton({
  Image = "",
  Size = {40, 40},
  Color = Color3.fromRGB(10, 10, 10),
  Corner = true,
  Stroke = false,
  StrokeColor = Color3.fromRGB(255, 0, 0)
})

--[[
  Image = "" <string> button image
  Size = {40, 40} <table> button size
  Color = Color3.fromRGB(10, 10, 10) <Color3>  Button background color
  Corner = true -- <boolean> Add a UICorner
  Stroke = false <boolean> Add a UIStroke
  StrokeColor = Color3.fromRGB(255, 0, 0) <Color3> UIStroke color
]]
```

## Creating a Tab
```lua
local Main = MakeTab({Name = "Main"})

--[[
  Name = "Main" <string> Tab name
]]
```

## Creating a Notify
```lua
MakeNotifi({
  Title = "REDz HUB",
  Text = "Notification Testing",
  Time = 5
})

--[[
  Title = "skibidi" <string> notification title
  Text = "Notification Testing" <string> notification description
  Time = 5 <number> notification time
]]
```

## Creating a Section
```lua
local section = AddSection(Main, {"Test"})
--[[
  {"Test"} <table> window name
]]
```

## Creating a Set Section
```lua
SetSection(section, "HI")
```

## Creating a Button
```lua
AddButton(Main, {
  Name = "Button Testing",
  Callback = function()
    
  end
})

--[[
  Name = "Button Testing" <string> name of your button
  Callback = function()
    -- function of your button
  end
]]
```

## Creating a Toggle
```lua
local Toggle = AddToggle(Main, {
  Name = "Toggle Test",
  Default = false,
  Callback = function(Value)
    
  end
})

--[[
  Name = "Toggle Test" <string> name of your checkbox
  Default = false <boolean> standard value
  Callback = function(Value)
    -- function of your checkbox
  end
]]
```

## Creating a Mobile Toggle
```lua
local MobileToggle = AddMobileToggle({
  Name = "Toggle",
  Visible = true,
  Callback = function(Value)
    
  end
})

MobileToggle.Visible = (false/true)

--[[
  Name = "Toggle" <string> Check box name
  Visible = false <boolean> Make it invisible or visible
  Callback = function()
    -- check box function
  end
]]
```

## Creating a Slider
```lua
local Slider = AddSlider(Main, {
  Name = "Slider Test",
  MinValue = 10,
  MaxValue = 100,
  Default = 25,
  Increase = 1,
  Callback = function(Value)
    
  end
})

--[[
  Name = "Slider teste" <string> slider name
  MinValue = 10 <number> minimum value
  MaxValue = 100 <number> maximum value
  Default = 25 <number> standard value
  Increase = 1 <number> value that increases according to the position of the
  Callback = function(Value)
    slider function
  end
]]
```

## Creating a Keybind
```lua
AddKeybind(Main, {
  Name = "Keybind Test",
  KeyCode = "E",
  Default = false,
  Callback = function(Value)
    
  end
})

--[[
  Name = "Keybind teste" <string> keyboard shortcut name
  KeyCode = "E" <string> key
  Default = false <boolean> default value (this will act as a checkbox)
  Callback = function(Value)
    -- keyboard shortcut function
  end
]]
```

## Creating a TextBox
```lua
AddTextBox(Main, {
  Name = "TextBox Test",
  Default = "Th4m",
  PlaceholderText = "hub",
  ClearText = true,
  Callback = function(Value)
    
  end
})

--[[
  Name = "TextBox Test" <string> Text box name
  Default = "skibidi" <string> default text
  PlaceholderText = "hub" <string> text that will show when the checkbox has no text
  ClearText = true <boolean> does not delete text when you open the text box
  Callback = function(Value)
    -- text box function
  end
]]
```

## Creating a Dropdown
```lua
local Dropdown = AddDropdown(Main, {
  Name = "Dropdown Test",
  Options = {"skibidi", "123", "toilet"},
  Default = "2",
  Callback = function(Value)
    
  end
})

--[[
  Name = "Dropdown teste" <string> dropdown menu name
  Options = {"1", "2", "3"} <table> list of options
  Default = "2" <string> default option
  Callback = function(Value)
    -- dropdown menu function
  end
]]
```

## Creating a Color Picker
```lua
AddColorPicker(Main, {
  Name = "Color Picker Test",
  Default = Color3.fromRGB(255, 255, 0),
  Callback = function(Value)
    
  end
})

--[[
  Name = "Color picker teste" <string> Color sector name
  Default = Color3.fromRGB(255, 255, 0) <Color3> Sets the default color of the color sector
  Callback = function(Value)
    -- color sector function
  end
]]
```

## Creating a Paragraph
```lua
local Paragraph = AddParagraph(Main, {"Paragraph Test", "hello"})

--[[
  <string> Paragraph Name
  <string> description of the Paragraph
]]
```
## Creating a Set Paragraph 
```lua
SetParagraph(Paragraph, {"Paragraph", ":>"})

--[[
  <string> new Paragraph Name
  <string> New Paragraph description
]]
```

## Creating a Label
```lua
local Label = AddTextLabel(Main, "aimbot in arsenal")

--[[
  <string> Text
]]
```

## Creating a Set Label
```lua
SetLabel(Label, "script")

--[[
  <string> new Text
]]
```

## Creating a Image Label
```lua
local Image = AddImageLabel(Main, {
  Name = "Cool Image",
  Image = "rbxassetid://"
})

--[[
  Name = "Cool Image" <string> Image name
  Image = "rbxassetid://" <string> image id
]]
```

## Set Image
```lua
SetImage(Image, "rbxassetid://4155801252")

--[[
  <string> New image
]]
```

## Destroy UI / Script
```lua
DestroyScript()
```
## Extra

## Update Toggle
```lua
UpdateToggle(Toggle, true)
```

## Update Slider
```lua
UpdateSlider(Slider, 25)

--[[
  <number> new slider value
]]
```

## Update DropDown
```lua
UpdateDropdown(Dropdown, {"Edited -> th4m", "skided", "creds -> redzhub"})

--[[
  {"u ", "hello", "redzhub"} <table> new dropdown menu options
]]
```
