# mega_nplayerselector

Lua library for RedM which allows to select players around you by clicking on the screen at their position.

## 🌠 Showcase

![Showcase](https://cdn.discordapp.com/attachments/776118735764717578/940338885119066203/playerselector_showcase_gif.gif)

## 👨‍💻 Usage

```lua

local NPlayerSelector = nil
TriggerEvent('mega_nplayerselector:load', function (data)
    NPlayerSelector = data
end)

NPlayerSelector:onPlayerSelected(function (data)
  -- do stuff...
  -- data = { id = ... }
  NPlayerSelector:deactivate()
end)

NPlayerSelector:setRange(5)
NPlayerSelector:activate()
```

