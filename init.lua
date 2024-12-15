-- i will touch you if you PASTE MY INIT SCRIPTTTTTT

if not game:IsLoaded() then game.Loaded:Wait() end

getgenv().consoleclear = function() end
getgenv().consolecreate = function() end
getgenv().consoledestroy = function() end
getgenv().consoleinput = function() end
getgenv().consoleprint = function() end
getgenv().consolesettitle = function() end
getgenv().rconsolename = function() end

local testdebug = table.clone(debug)

testdebug.getconstant = getgenv().getconstant
testdebug.getconstants = getgenv().getconstants
testdebug.getinfo = getgenv().getinfo
testdebug.setconstant = getgenv().setconstant
testdebug.getproto = getgenv().getproto
testdebug.getprotos = getgenv().getprotos
testdebug.getstack = getgenv().getstack
testdebug.setstack = getgenv().setstack
testdebug.getupvalue = getgenv().getupvalue
testdebug.getupvalues = getgenv().getupvalues
testdebug.setupvalue = getgenv().setupvalue
testdebug.getregistry = getgenv().getregistry

debug = testdebug

getgenv().bit = {}

for i, v in next, bit32 do
bit[i] = v
end

bit.ror = bit.rrotate
bit.rol = bit.lrotate
bit.rrotate = nil
bit.lrotate = nil

bit.badd = function(a, b)
   return a + b
end

bit.bsub = function(a, b)
   return a - b
end

bit.bdiv = function(a, b)
   return a / b
end

bit.bmul = function(a, b)
   return a * b
end

bit.tobit = function(x)
  x = x % (2^32)
  if x >= 0x80000000 then x = x - (2^32) end
  return x
end

bit.tohex = function(x, n)
 n = n or 8
 local up
 if n <= 0 then
   if n == 0 then return '' end
   up = true
   n = - n
 end
 x = bit.band(x, 16^n-1)
 return ('%0'..n..(up and 'X' or 'x')):format(x)
end

bit.bswap = function(x)
 local a = bit.band(x, 0xff)
 x = bit.rshift(x, 8)
 local b = bit.band(x, 0xff)
 x = bit.rshift(x, 8)
 local c = bit.band(x, 0xff)
 x = bit.rshift(x, 8)
 local d = bit.band(x, 0xff)
 return bit.lshift(bit.lshift(bit.lshift(a, 8) + b, 8) + c, 8) + d
end

getgenv().setthreadidentity = function(identity: number): ()
    _setidentity(identity)
    task.wait()
end

getgenv().setidentity = getgenv().setthreadidentity
getgenv().setthreadcontext = getgenv().setthreadidentity

getgenv().getinstances = function()
            local objs = {}
            for i,v in next, getreg() do
               if type(v)=='table' then
                  for o,b in next, v do
                      if typeof(b) == "Instance" then
                           table.insert(objs, b)
                      end
                  end
               end
            end
         return objs
 end


do
    local CoreGui = game:GetService('CoreGui')
    local HttpService = game:GetService('HttpService')

    local comm_channels = CoreGui:FindFirstChild('comm_channels') or Instance.new('Folder', CoreGui)
    if comm_channels.Name ~= 'comm_channels' then
        comm_channels.Name = 'comm_channels'
    end
    getgenv().create_comm_channel = newcclosure(function() 
        local id = HttpService:GenerateGUID()
        local event = Instance.new('BindableEvent', comm_channels)
        event.Name = id
        return id, event
    end)

    getgenv().get_comm_channel = newcclosure(function(id) 
        assert(type(id) == 'string', 'string expected as argument #1')
        return comm_channels:FindFirstChild(id)
    end)
end

getgenv().getactors = newcclosure(function()
    local actors = {};
    for i, v in game:GetDescendants() do
        if v:IsA("Actor") then
            table.insert(actors, v);
        end
    end
    return actors;
end);

getgenv().getnilinstances = function()
    local objs = {}
	for i,v in next,getreg() do
		if type(v)=="table" then
			for o,b in next,v do
				if typeof(b) == "Instance" and b.Parent==nil then
					table.insert(objs, b)
				end
			end
		end
	end
	return objs
end

getgenv().getscripts = function()
    local scripts = {}
    for i, v in pairs(game:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            table.insert(scripts, v)
        end
    end
    return scripts
end

getgenv().getscripthash = function(script)
    return script:GetHash()
end

setreadonly(getgenv().debug,false)
getgenv().debug.traceback = getrenv().debug.traceback
getgenv().debug.profilebegin = getrenv().debug.profilebegin
getgenv().debug.profileend = getrenv().debug.profileend
getgenv().debug.getmetatable = getgenv().getrawmetatable
getgenv().debug.setmetatable = getgenv().setrawmetatable
getgenv().debug.info = getrenv().debug.info

getgenv().getrunningscripts = function()
    local t = table.create(0)

    for i,v in pairs(getreg()) do
        if typeof(v) == "thread" then
            local a = gettenv(v)

            if a["script"] then
                if not table.find(t,a.script) then
                    table.insert(t, a.script)
                end
            end
        end
    end

return t

end

getgenv().getloadedmodules = function()
    local list = {}
    for i, v in getgc(false) do
        if typeof(v) == "function" then
            local success, env = pcall(getfenv, v)
            if success and typeof(env) == "table" and typeof(env["script"]) == "Instance" and env["script"]:IsA("ModuleScript") then
                if not table.find(list, env["script"]) then
                    table.insert(list, env["script"])
                end
            end
        end
    end
    return list
end

getgenv().getsenv = function(script_instance)
   for i, v in pairs(getreg()) do
      if type(v) == "function" then
         if getfenv(v).script == script_instance then
             return getfenv(v)
             end
          end
     end
end

getgenv().isnetworkowner = function(part: BasePart): boolean
    return part.ReceiveAge == 0 and not part.Anchored and part.Velocity.Magnitude > 0
end

getgenv().firesignal = function(signal, ...)
    local connections = getconnections(signal)
    for _, connection in connections do
        connection.Function(...)
    end
end

getgenv().setsimulationradius = function(newRadius)
    assert(newRadius, `arg #1 is missing`)
    assert(type(newRadius) == "number", `arg #1 must be type number`)

    local LocalPlayer = game:GetService("Players").LocalPlayer
    if LocalPlayer then
        LocalPlayer.SimulationRadius = newRadius
        LocalPlayer.MaximumSimulationRadius = newRadius
    end
end

getgenv().getsimulationradius = function()
    assert(newRadius, `arg #1 is missing`)
    assert(type(newRadius) == "number", `arg #1 must be type number`)

    local LocalPlayer = game:GetService("Players").LocalPlayer
    if LocalPlayer then
        return LocalPlayer.SimulationRadius
    end
end

getgenv().fireproximityprompt = function(proximityprompt, amount, skip)
    assert(
        typeof(proximityprompt) == "Instance" and proximityprompt:IsA("ProximityPrompt"),
        `arg #1 must be ProximityPrompt`
    )

    if amount ~= nil then
        assert(type(amount) == "number", `arg #2 must be type number`)
        if skip ~= nil then
            assert(type(skip) == "boolean", `arg #3 must be type boolean`)
        end
    end

    local oldHoldDuration = proximityprompt.HoldDuration
    local oldMaxDistance = proximityprompt.MaxActivationDistance

    proximityprompt.MaxActivationDistance = 9e9 -- client replicated only
    proximityprompt:InputHoldBegin()

    for i = 1, amount or 1 do -- or 1 cuz number can be nil
        if skip then
            proximityprompt.HoldDuration = 0
        else
            task.wait(proximityprompt.HoldDuration + 0.01) -- better than wait()
        end
    end

    proximityprompt:InputHoldEnd()
    proximityprompt.MaxActivationDistance = oldMaxDistance
    proximityprompt.HoldDuration = oldHoldDuration
end

getgenv().http = {}
getgenv().http.request = request
setreadonly(http, true)

getgenv().http_request = request

getgenv().base64 = {}
getgenv().crypt = {}
getgenv().crypt.base64 = {}

getgenv().crypt.base64encode = getgenv().base64encode
getgenv().crypt.base64.encode = getgenv().base64encode
getgenv().crypt.base64_encode = getgenv().base64encode
getgenv().base64.encode = getgenv().base64encode
getgenv().base64_encode = getgenv().base64encode

getgenv().crypt.base64decode = getgenv().base64decode
getgenv().crypt.base64.decode = getgenv().base64decode
getgenv().crypt.base64_decode = getgenv().base64decode
getgenv().base64.decode = getgenv().base64decode
getgenv().base64_decode = getgenv().base64decode

getgenv().crypt.encrypt = getgenv().encrypt
getgenv().crypt.decrypt = getgenv().decrypt

getgenv().crypt.generatebytes = getgenv().generatebytes

getgenv().crypt.generatekey = getgenv().generatekey
getgenv().crypt.hash = getgenv().hash

setreadonly(getgenv().base64, true)
setreadonly(getgenv().crypt, true)

local _oldd = clonefunction(getscriptclosure_handler)

getgenv().getscriptclosure = newcclosure(function(scr) 
	local closure = _oldd(scr)

	if typeof(closure) == "function" then
		local scriptEnv = getfenv(closure)

		scriptEnv["script"] = scr

		return closure
	else
		return nil
	end
end)

getgenv().getscriptfunction = getgenv().getscriptclosure

local oldreq = clonefunction(getrenv().require)
getgenv().require = newcclosure(function(v)
    local oldlevel = getthreadcontext()
    local succ, res = pcall(oldreq, v)
    if not succ and res:find('RobloxScript') then
        succ = nil
        coroutine.resume(coroutine.create(newcclosure(function()
            setthreadcontext((oldlevel > 5 and 2) or 8)
            succ, res = pcall(oldreq, v)
        end)))
        repeat task.wait() until succ ~= nil
    end
    
    setthreadcontext(oldlevel)
    
    if succ then
        return res
    end
end)
if not game:IsLoaded() then
    game.Loaded:Wait();
end

local Player = game:GetService('Players').LocalPlayer;
	   
repeat wait() until game:IsLoaded() -- precaution

--[[ Variables ]]--

local textService = cloneref(game:GetService("TextService"));

local drawing = {
    Fonts = {
        UI = 0,
        System = 1,
        Plex = 2,
        Monospace = 3
    }
};

local renv = getrenv();
local genv = getgenv();

local pi = renv.math.pi;
local huge = renv.math.huge;

local _assert = (renv.assert);
local _color3new = (renv.Color3.new);
local _instancenew = (renv.Instance.new);
local _mathatan2 = (renv.math.atan2);
local _mathclamp = (renv.math.clamp);
local _mathmax = (renv.math.max);
local _setmetatable = (renv.setmetatable);
local _stringformat = (renv.string.format);
local _typeof = (renv.typeof);
local _taskspawn = (renv.task.spawn);
local _udimnew = (renv.UDim.new);
local _udim2fromoffset = (renv.UDim2.fromOffset);
local _udim2new = (renv.UDim2.new);
local _vector2new = (renv.Vector2.new);

local _destroy = (game.Destroy);
local _gettextboundsasync = (textService.GetTextBoundsAsync);

local _httpget = (game.HttpGet);
local _writecustomasset = function(path, data)
	writefile(path,data)
	return getcustomasset(path)
end

--[[ Functions ]]--

local function create(className, properties, children)
	local inst = _instancenew(className);
	for i, v in properties do
		if i ~= "Parent" then
			inst[i] = v;
		end
	end
	if children then
		for i, v in children do
			v.Parent = inst;
		end
	end
	inst.Parent = properties.Parent;
	return inst;
end

--[[ Setup ]]--

do -- This may look completely useless, but it allows TextBounds to update without yielding and therefore breaking the metamethods.
	local fonts = {
		Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	};

	for i, v in fonts do
		game:GetService("TextService"):GetTextBoundsAsync(create("GetTextBoundsParams", {
			Text = "Hi",
			Size = 12,
			Font = v,
			Width = huge
		}));
	end
end

--[[ Drawing ]]--

do
    local drawingDirectory = create("ScreenGui", {
        DisplayOrder = 15,
        IgnoreGuiInset = true,
        Name = "drawingDirectory",
        Parent = game.CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    });
	
	local function updatePosition(frame, from, to, thickness)
		local central = (from + to) / 2;
		local offset = to - from;
		frame.Position = _udim2fromoffset(central.X, central.Y);
		frame.Rotation = _mathatan2(offset.Y, offset.X) * 180 / pi;
		frame.Size = _udim2fromoffset(offset.Magnitude, thickness);
	end

    local itemCounter = 0;
    local cache = {};

    local classes = {};
    do
        local line = {};

        function line.new()
            itemCounter = itemCounter + 1;
            local id = itemCounter;

            local newLine = _setmetatable({
                _id = id,
                __OBJECT_EXISTS = true,
                _properties = {
                    Color = _color3new(),
                    From = _vector2new(),
                    Thickness = 1,
                    To = _vector2new(),
                    Transparency = 1,
                    Visible = false,
                    ZIndex = 0
                },
                _frame = create("Frame", {
                    Name = id,
                    AnchorPoint = _vector2new(0.5, 0.5),
                    BackgroundColor3 = _color3new(),
                    BorderSizePixel = 0,
                    Parent = drawingDirectory,
                    Position = _udim2new(),
                    Size = _udim2new(),
                    Visible = false,
                    ZIndex = 0
                })
            }, line);

            cache[id] = newLine;
            return newLine;
        end

        function line:__index(k)
			local prop = self._properties[k];
			if prop ~= nil then
				return prop;
			end
			return line[k];
        end

        function line:__newindex(k, v)
            if self.__OBJECT_EXISTS == true then
                self._properties[k] = v;
                if k == "Color" then
                    self._frame.BackgroundColor3 = v;
                elseif k == "From" then
                    self:_updatePosition();
                elseif k == "Thickness" then
                    self._frame.Size = _udim2fromoffset(self._frame.AbsoluteSize.X, _mathmax(v, 1));
                elseif k == "To" then
                    self:_updatePosition();
                elseif k == "Transparency" then
                    self._frame.BackgroundTransparency = _mathclamp(1 - v, 0, 1);
                elseif k == "Visible" then
                    self._frame.Visible = v;
                elseif k == "ZIndex" then
                    self._frame.ZIndex = v;
                end
            end
        end
		
		function line:__iter()
            return next, self._properties;
        end
		
		function line:__tostring()
			return "Drawing";
		end

        function line:Destroy()
			cache[self._id] = nil;
            self.__OBJECT_EXISTS = false;
            _destroy(self._frame);
        end

        function line:_updatePosition()
			local props = self._properties;
			updatePosition(self._frame, props.From, props.To, props.Thickness);
        end

        line.Remove = line.Destroy;
        classes.Line = line;
    end
    
    do
        local circle = {};

        function circle.new()
            itemCounter = itemCounter + 1;
            local id = itemCounter;

            local newCircle = _setmetatable({
                _id = id,
                __OBJECT_EXISTS = true,
                _properties = {
                    Color = _color3new(),
                    Filled = false,
					NumSides = 0,
                    Position = _vector2new(),
                    Radius = 0,
                    Thickness = 1,
                    Transparency = 1,
                    Visible = false,
                    ZIndex = 0
                },
                _frame = create("Frame", {
                    Name = id,
                    AnchorPoint = _vector2new(0.5, 0.5),
                    BackgroundColor3 = _color3new(),
					BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Parent = drawingDirectory,
                    Position = _udim2new(),
                    Size = _udim2new(),
                    Visible = false,
                    ZIndex = 0
                }, {
                    create("UICorner", {
                        Name = "_corner",
                        CornerRadius = _udimnew(1, 0)
                    }),
                    create("UIStroke", {
                        Name = "_stroke",
                        Color = _color3new(),
                        Thickness = 1
                    })
                })
            }, circle);

            cache[id] = newCircle;
            return newCircle;
        end

        function circle:__index(k)
			local prop = self._properties[k];
			if prop ~= nil then
				return prop;
			end
			return circle[k];
        end

        function circle:__newindex(k, v)
            if self.__OBJECT_EXISTS == true then
				local props = self._properties;
                props[k] = v;
                if k == "Color" then
                    self._frame.BackgroundColor3 = v;
                    self._frame._stroke.Color = v;
                elseif k == "Filled" then
                    self._frame.BackgroundTransparency = v and 1 - props.Transparency or 1;
                elseif k == "Position" then
                    self._frame.Position = _udim2fromoffset(v.X, v.Y);
                elseif k == "Radius" then
					self:_updateRadius();
                elseif k == "Thickness" then
                    self._frame._stroke.Thickness = _mathmax(v, 1);
					self:_updateRadius();
                elseif k == "Transparency" then
					self._frame._stroke.Transparency = 1 - v;
					if props.Filled then
						self._frame.BackgroundTransparency = 1 - v;
					end
                elseif k == "Visible" then
                    self._frame.Visible = v;
                elseif k == "ZIndex" then
                    self._frame.ZIndex = v;
                end
            end
        end
		
		function circle:__iter()
            return next, self._properties;
        end
		
		function circle:__tostring()
			return "Drawing";
		end

        function circle:Destroy()
			cache[self._id] = nil;
            self.__OBJECT_EXISTS = false;
            _destroy(self._frame);
        end
		
		function circle:_updateRadius()
			local props = self._properties;
			local diameter = (props.Radius * 2) - (props.Thickness * 2);
			self._frame.Size = _udim2fromoffset(diameter, diameter);
		end

        circle.Remove = circle.Destroy;
        classes.Circle = circle;
    end

	do
		local enumToFont = {
			[drawing.Fonts.UI] = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			[drawing.Fonts.System] = Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			[drawing.Fonts.Plex] = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			[drawing.Fonts.Monospace] = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		};

		local text = {};
		
		function text.new()
			itemCounter = itemCounter + 1;
            local id = itemCounter;

            local newText = _setmetatable({
                _id = id,
                __OBJECT_EXISTS = true,
                _properties = {
					Center = false,
					Color = _color3new(),
					Font = 0,
					Outline = false,
					OutlineColor = _color3new(),
					Position = _vector2new(),
					Size = 12,
					Text = "",
					TextBounds = _vector2new(),
					Transparency = 1,
					Visible = false,
					ZIndex = 0
                },
                _frame = create("TextLabel", {
					Name = id,
					BackgroundTransparency = 1,
					FontFace = enumToFont[0],
                    Parent = drawingDirectory,
                    Position = _udim2new(),
                    Size = _udim2new(),
					Text = "",
					TextColor3 = _color3new(),
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
                    Visible = false,
                    ZIndex = 0
				}, {
					create("UIStroke", {
						Name = "_stroke",
						Color = _color3new(),
						Enabled = false,
						Thickness = 1
					})
				})
            }, text);

            cache[id] = newText;
            return newText;
		end

		function text:__index(k)
			local prop = self._properties[k];
			if prop ~= nil then
				return prop;
			end
			return text[k];
        end

        function text:__newindex(k, v)
            if self.__OBJECT_EXISTS == true then
                if k ~= "TextBounds" then
					self._properties[k] = v;
				end
				if k == "Center" then
					self._frame.TextXAlignment = v and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left;
				elseif k == "Color" then
					self._frame.TextColor3 = v;
				elseif k == "Font" then
					self._frame.FontFace = enumToFont[v];
					self:_updateTextBounds();
				elseif k == "Outline" then
					self._frame._stroke.Enabled = v;
				elseif k == "OutlineColor" then
					self._frame._stroke.Color = v;
				elseif k == "Position" then
					self._frame.Position = _udim2fromoffset(v.X, v.Y);
				elseif k == "Size" then
					self._frame.TextSize = v;
					self:_updateTextBounds();
				elseif k == "Text" then
					self._frame.Text = v;
					self:_updateTextBounds();
				elseif k == "Transparency" then
					self._frame.TextTransparency = 1 - v;
					self._frame._stroke.Transparency = 1 - v;
				elseif k == "Visible" then
					self._frame.Visible = v;
				elseif k == "ZIndex" then
					self._frame.ZIndex = v;
				end
            end
        end
		
		function text:__iter()
            return next, self._properties;
        end
		
		function text:__tostring()
			return "Drawing";
		end

        function text:Destroy()
			cache[self._id] = nil;
            self.__OBJECT_EXISTS = false;
            _destroy(self._frame);
        end

		function text:_updateTextBounds()
			local props = self._properties;
			props.TextBounds = _gettextboundsasync(textService, create("GetTextBoundsParams", {
				Text = props.Text,
				Size = props.Size,
				Font = enumToFont[props.Font],
				Width = huge
			}));
		end

		text.Remove = text.Destroy;
		classes.Text = text;
	end

	do
		local square = {};

		function square.new()
			itemCounter = itemCounter + 1;
			local id = itemCounter;

			local newSquare = _setmetatable({
                _id = id,
                __OBJECT_EXISTS = true,
				_properties = {
					Color = _color3new(),
					Filled = false,
					Position = _vector2new(),
					Size = _vector2new(),
					Thickness = 1,
					Transparency = 1,
					Visible = false,
					ZIndex = 0
				},
				_frame = create("Frame", {
					BackgroundColor3 = _color3new(),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = drawingDirectory,
                    Position = _udim2new(),
                    Size = _udim2new(),
                    Visible = false,
                    ZIndex = 0
				}, {
					create("UIStroke", {
						Name = "_stroke",
						Color = _color3new(),
						Thickness = 1
					})
				})
			}, square);
			
			cache[id] = newSquare;
			return newSquare;
		end

		function square:__index(k)
			local prop = self._properties[k];
			if prop ~= nil then
				return prop;
			end
			return square[k];
        end

        function square:__newindex(k, v)
            if self.__OBJECT_EXISTS == true then
				local props = self._properties;
				props[k] = v;
				if k == "Color" then
					self._frame.BackgroundColor3 = v;
					self._frame._stroke.Color = v;
				elseif k == "Filled" then
					self._frame.BackgroundTransparency = v and 1 - props.Transparency or 1;
				elseif k == "Position" then
					self:_updateScale();
				elseif k == "Size" then
					self:_updateScale();
				elseif k == "Thickness" then
					self._frame._stroke.Thickness = v;
					self:_updateScale();
				elseif k == "Transparency" then
					self._frame._stroke.Transparency = 1 - v;
					if props.Filled then
						self._frame.BackgroundTransparency = 1 - v;
					end
				elseif k == "Visible" then
					self._frame.Visible = v;
				elseif k == "ZIndex" then
					self._frame.ZIndex = v;
				end
            end
        end
		
		function square:__iter()
            return next, self._properties;
        end
		
		function square:__tostring()
			return "Drawing";
		end

        function square:Destroy()
			cache[self._id] = nil;
            self.__OBJECT_EXISTS = false;
            _destroy(self._frame);
        end

		function square:_updateScale()
			local props = self._properties;
			self._frame.Position = _udim2fromoffset(props.Position.X + props.Thickness, props.Position.Y + props.Thickness);
			self._frame.Size = _udim2fromoffset(props.Size.X - props.Thickness * 2, props.Size.Y - props.Thickness * 2);
		end

		square.Remove = square.Destroy;
		classes.Square = square;
	end
	
	  

do
		local image = {};

		function image.new()
			itemCounter = itemCounter + 1;
			local id = itemCounter;

			local newImage = _setmetatable({
				_id = id,
				_imageId = 0,
				__OBJECT_EXISTS = true,
				_properties = {
					Color = _color3new(1, 1, 1),
					Data = "",
					Position = _vector2new(),
					Rounding = 0,
					Size = _vector2new(),
					Transparency = 1,
					Uri = "",
					Visible = false,
					ZIndex = 0
				},
				_frame = create("ImageLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = "",
					ImageColor3 = _color3new(1, 1, 1),
					Parent = drawingDirectory,
                    Position = _udim2new(),
                    Size = _udim2new(),
                    Visible = false,
                    ZIndex = 0
				}, {
					create("UICorner", {
						Name = "_corner",
						CornerRadius = _udimnew()
					})
				})
			}, image);
			
			cache[id] = newImage;
			return newImage;
		end

		function image:__index(k)
			_assert(k ~= "Data", _stringformat("Attempt to read writeonly property '%s'", k));
			if k == "Loaded" then
				return self._frame.IsLoaded;
			end
			local prop = self._properties[k];
			if prop ~= nil then
				return prop;
			end
			return image[k];
		end

		function image:__newindex(k, v)
			if self.__OBJECT_EXISTS == true then
				self._properties[k] = v;
				if k == "Color" then
					self._frame.ImageColor3 = v;
				elseif k == "Data" then
					self:_newImage(v);
				elseif k == "Position" then
					self._frame.Position = _udim2fromoffset(v.X, v.Y);
				elseif k == "Rounding" then
					self._frame._corner.CornerRadius = _udimnew(0, v);
				elseif k == "Size" then
					self._frame.Size = _udim2fromoffset(v.X, v.Y);
				elseif k == "Transparency" then
					self._frame.ImageTransparency = 1 - v;
				elseif k == "Uri" then
					self:_newImage(v, true);
				elseif k == "Visible" then
					self._frame.Visible = v;
				elseif k == "ZIndex" then
					self._frame.ZIndex = v;
				end
			end
		end
		
		function image:__iter()
            return next, self._properties;
        end
		
		function image:__tostring()
			return "Drawing";
		end

		function image:Destroy()
			cache[self._id] = nil;
			self.__OBJECT_EXISTS = false;
			_destroy(self._frame);
		end

		function image:_newImage(data, isUri)
			_taskspawn(function() -- this is fucked but u can't yield in a metamethod
				self._imageId = self._imageId + 1;
				local path = _stringformat("%s-%s.png", self._id, self._imageId);
				if isUri then
					data = _httpget(game, data, true);
					self._properties.Data = data;
				else
					self._properties.Uri = "";
				end
				self._frame.Image = _writecustomasset(path, data);
			end);
		end

		image.Remove = image.Destroy;
		classes.Image = image;
	end

	do
		local triangle = {};

		function triangle.new()
			itemCounter = itemCounter + 1;
			local id = itemCounter;

			local newTriangle = _setmetatable({
				_id = id,
				__OBJECT_EXISTS = true,
				_properties = {
					Color = _color3new(),
					Filled = false,
					PointA = _vector2new(),
					PointB = _vector2new(),
					PointC = _vector2new(),
					Thickness = 1,
					Transparency = 1,
					Visible = false,
					ZIndex = 0
				},
				_frame = create("Frame", {
					BackgroundTransparency = 1,
					Parent = drawingDirectory,
					Size = _udim2new(1, 0, 1, 0),
					Visible = false,
					ZIndex = 0
				}, {
					create("Frame", {
						Name = "_line1",
						AnchorPoint = _vector2new(0.5, 0.5),
						BackgroundColor3 = _color3new(),
						BorderSizePixel = 0,
						Position = _udim2new(),
						Size = _udim2new(),
						ZIndex = 0
					}),
					create("Frame", {
						Name = "_line2",
						AnchorPoint = _vector2new(0.5, 0.5),
						BackgroundColor3 = _color3new(),
						BorderSizePixel = 0,
						Position = _udim2new(),
						Size = _udim2new(),
						ZIndex = 0
					}),
					create("Frame", {
						Name = "_line3",
						AnchorPoint = _vector2new(0.5, 0.5),
						BackgroundColor3 = _color3new(),
						BorderSizePixel = 0,
						Position = _udim2new(),
						Size = _udim2new(),
						ZIndex = 0
					})
				})
			}, triangle);
			
			cache[id] = newTriangle;
			return newTriangle;
		end

		function triangle:__index(k)
			local prop = self._properties[k];
			if prop ~= nil then
				return prop;
			end
			return triangle[k];
		end

		function triangle:__newindex(k, v)
			if self.__OBJECT_EXISTS == true then
				local props, frame = self._properties, self._frame;
				props[k] = v;
				if k == "Color" then
					frame._line1.BackgroundColor3 = v;
					frame._line2.BackgroundColor3 = v;
					frame._line3.BackgroundColor3 = v;
				elseif k == "Filled" then
					-- TODO
				elseif k == "PointA" then
					self:_updateVertices({
						{ frame._line1, props.PointA, props.PointB },
						{ frame._line3, props.PointC, props.PointA }
					});
					if props.Filled then
						self:_calculateFill();
					end
				elseif k == "PointB" then
					self:_updateVertices({
						{ frame._line1, props.PointA, props.PointB },
						{ frame._line2, props.PointB, props.PointC }
					});
					if props.Filled then
						self:_calculateFill();
					end
				elseif k == "PointC" then
					self:_updateVertices({
						{ frame._line2, props.PointB, props.PointC },
						{ frame._line3, props.PointC, props.PointA }
					});
					if props.Filled then
						self:_calculateFill();
					end
				elseif k == "Thickness" then
					local thickness = _mathmax(v, 1);
                    frame._line1.Size = _udim2fromoffset(frame._line1.AbsoluteSize.X, thickness);
                    frame._line2.Size = _udim2fromoffset(frame._line2.AbsoluteSize.X, thickness);
                    frame._line3.Size = _udim2fromoffset(frame._line3.AbsoluteSize.X, thickness);
				elseif k == "Transparency" then
					frame._line1.BackgroundTransparency = 1 - v;
					frame._line2.BackgroundTransparency = 1 - v;
					frame._line3.BackgroundTransparency = 1 - v;
				elseif k == "Visible" then
					self._frame.Visible = v;
				elseif k == "ZIndex" then
					self._frame.ZIndex = v;
				end
			end
		end
		
		function triangle:__iter()
            return next, self._properties;
        end
		
		function triangle:__tostring()
			return "Drawing";
		end

		function triangle:Destroy()
			cache[self._id] = nil;
            self.__OBJECT_EXISTS = false;
            _destroy(self._frame);
		end

		function triangle:_updateVertices(vertices)
			local thickness = self._properties.Thickness;
			for i, v in vertices do
				updatePosition(v[1], v[2], v[3], thickness);
			end
		end

		function triangle:_calculateFill()
		
		end

		triangle.Remove = triangle.Destroy;
		classes.Triangle = triangle;
	end
	
	do
		local quad = {};
		
		function quad.new()
			itemCounter = itemCounter + 1;
			local id = itemCounter;
			
			local newQuad = _setmetatable({
				_id = id,
				__OBJECT_EXISTS = true,
				_properties = {
					Color = _color3new(),
					Filled = false,
					PointA = _vector2new(),
					PointB = _vector2new(),
					PointC = _vector2new(),
					PointD = _vector2new(),
					Thickness = 1,
					Transparency = 1,
					Visible = false,
					ZIndex = 0
				},
				_frame = create("Frame", {
					BackgroundTransparency = 1,
					Parent = drawingDirectory,
					Size = _udim2new(1, 0, 1, 0),
					Visible = false,
					ZIndex = 0
				}, {
					create("Frame", {
						Name = "_line1",
						AnchorPoint = _vector2new(0.5, 0.5),
						BackgroundColor3 = _color3new(),
						BorderSizePixel = 0,
						Position = _udim2new(),
						Size = _udim2new(),
						ZIndex = 0
					}),
					create("Frame", {
						Name = "_line2",
						AnchorPoint = _vector2new(0.5, 0.5),
						BackgroundColor3 = _color3new(),
						BorderSizePixel = 0,
						Position = _udim2new(),
						Size = _udim2new(),
						ZIndex = 0
					}),
					create("Frame", {
						Name = "_line3",
						AnchorPoint = _vector2new(0.5, 0.5),
						BackgroundColor3 = _color3new(),
						BorderSizePixel = 0,
						Position = _udim2new(),
						Size = _udim2new(),
						ZIndex = 0
					}),
					create("Frame", {
						Name = "_line4",
						AnchorPoint = _vector2new(0.5, 0.5),
						BackgroundColor3 = _color3new(),
						BorderSizePixel = 0,
						Position = _udim2new(),
						Size = _udim2new(),
						ZIndex = 0
					})
				})
			}, quad);
			
			cache[id] = newQuad;
			return newQuad;
		end
		
		function quad:__index(k)
			local prop = self._properties[k];
			if prop ~= nil then
				return prop;
			end
			return quad[k];
		end

		function quad:__newindex(k, v)
			if self.__OBJECT_EXISTS == true then
				local props, frame = self._properties, self._frame;
				props[k] = v;
				if k == "Color" then
					frame._line1.BackgroundColor3 = v;
					frame._line2.BackgroundColor3 = v;
					frame._line3.BackgroundColor3 = v;
					frame._line4.BackgroundColor3 = v;
				elseif k == "Filled" then
					-- TODO
				elseif k == "PointA" then
					self:_updateVertices({
						{ frame._line1, props.PointA, props.PointB },
						{ frame._line4, props.PointD, props.PointA }
					});
					if props.Filled then
						self:_calculateFill();
					end
				elseif k == "PointB" then
					self:_updateVertices({
						{ frame._line1, props.PointA, props.PointB },
						{ frame._line2, props.PointB, props.PointC }
					});
					if props.Filled then
						self:_calculateFill();
					end
				elseif k == "PointC" then
					self:_updateVertices({
						{ frame._line2, props.PointB, props.PointC },
						{ frame._line3, props.PointC, props.PointD }
					});
					if props.Filled then
						self:_calculateFill();
					end
				elseif k == "PointD" then
					self:_updateVertices({
						{ frame._line3, props.PointC, props.PointD },
						{ frame._line4, props.PointD, props.PointA }
					});
					if props.Filled then
						self:_calculateFill();
					end
				elseif k == "Thickness" then
					local thickness = _mathmax(v, 1);
                    frame._line1.Size = _udim2fromoffset(frame._line1.AbsoluteSize.X, thickness);
                    frame._line2.Size = _udim2fromoffset(frame._line2.AbsoluteSize.X, thickness);
                    frame._line3.Size = _udim2fromoffset(frame._line3.AbsoluteSize.X, thickness);
                    frame._line4.Size = _udim2fromoffset(frame._line3.AbsoluteSize.X, thickness);
				elseif k == "Transparency" then
					frame._line1.BackgroundTransparency = 1 - v;
					frame._line2.BackgroundTransparency = 1 - v;
					frame._line3.BackgroundTransparency = 1 - v;
					frame._line4.BackgroundTransparency = 1 - v;
				elseif k == "Visible" then
					self._frame.Visible = v;
				elseif k == "ZIndex" then
					self._frame.ZIndex = v;
				end
			end
		end
	
		function quad:__iter()
            return next, self._properties;
        end
		
		function quad:__tostring()
			return "Drawing";
		end
	
		function quad:Destroy()
			cache[self._id] = nil;
			self.__OBJECT_EXISTS = false;
			_destroy(self._frame);
		end
		
		function quad:_updateVertices(vertices)
			local thickness = self._properties.Thickness;
			for i, v in vertices do
				updatePosition(v[1], v[2], v[3], thickness);
			end
		end

		function quad:_calculateFill()
		
		end
		
		quad.Remove = quad.Destroy;
		classes.Quad = quad;
	end

    drawing.new = function(x)
        return _assert(classes[x], _stringformat("Invalid drawing type '%s'", x)).new();
    end

    drawing.clear = function()
        for i, v in cache do
			if v.__OBJECT_EXISTS then
				v:Destroy();
			end
        end
    end

	drawing.cache = cache;
end

setreadonly(drawing, true);
setreadonly(drawing.Fonts, true);


genv.Drawing = drawing;
genv.cleardrawcache = drawing.clear;

genv.isrenderobj = function(x)
	--warn("erm: "..tostring(x))
	return tostring(x) == "Drawing";
end

genv.getrenderproperty = function(x, y)
	assert(isrenderobj(x), 'invalid drawing object')
    
    return x[y];
end

genv.setrenderproperty = function(x, y, z)
    assert(isrenderobj(x), 'invalid drawing object')
    x[y] = z;
end

local _isrenderobj = (isrenderobj);

genv.DRAWING_LOADED = true;
