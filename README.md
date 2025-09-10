# OKLCH for Roblox

A Roblox Lua module that provides **OKLCH <-> sRGB (Color3)** color space conversion.  
This is a pure math module without any UI — useful if you want to work with perceptually uniform colors in Roblox projects.

Original concept based on [oklch-picker](https://github.com/evilmartians/oklch-picker) by Evil Martians.  
This project is a **Roblox-compatible port** that focuses only on the conversion logic.

---

## ✨ Features
- Convert **OKLCH → Color3 (sRGB)**  
- Convert **Color3 (sRGB) → OKLCH**  
- Works as a standalone `ModuleScript` in Roblox  
- No dependencies

---

## 📦 Installation
1. Put the [`OKLCH.luau`](https://github.com/hschu-hschu/OKLCH.lua/blob/main/OKLCH.luau) file inside `ReplicatedStorage/Library/` or anywhere you want.
2. Require it from your scripts:
   ```lua
   local OKLCH = require(game.ReplicatedStorage.Library.OKLCH)
   ```

---

## 🚀 Usage

```lua
local OKLCH = require(game.ReplicatedStorage.Library.OKLCH)

-- Convert OKLCH to Roblox Color3
local col = OKLCH.toRGB(63.59, 57.81, 284.04)
print(col) -- Color3 value

-- Convert Color3 back to OKLCH
local L, C, H = OKLCH.fromRGB(col)
print(L, C, H)
```
