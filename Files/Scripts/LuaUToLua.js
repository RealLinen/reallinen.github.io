// If you want me to add support for more methods, reply on this thread: https://v3rm.net/threads/roblox-luau-to-lua-converter-js.10472/
// discord: reallinens

function replacePatterns(luaScript) {
    // Define patterns and their corresponding regexes
    const patterns = [
       // This is for local variable with type annotation
      { regex: /local\s+(\w+)\s*:\s*{([^{}]+)}\s*=\s*(.+)/g,
        format: "local $1 = $3" },

      // This is for arithmetic assignments
      { regex: /(\w+)\s*\+=\s*(\w+)/g, format: "$1 = $1 + $2" },
      { regex: /(\w+)\s*-=\s*(\w+)/g, format: "$1 = $1 - $2" },
      { regex: /(\w+)\s*\*=\s*(\w+)/g, format: "$1 = $1 * $2" },
      { regex: /(\w+)\s*\/=\s*(\w+)/g, format: "$1 = $1 / $2" },

      // This is for string concatenation (..=)
      { regex: /([\w\.\[\]\"\'\-]+)\s*\.\.=\s*([\w\"\']+)/g, format: "$1 = $1 .. $2" },

      // This is for for loop iteration
      { regex: /for\s+(\w+)\s*,\s*(\w+)\s*in\s*(\w+)\s*do/g, format: "for $1, $2 in next, $3 do" },

      // for loop iteration with type annotation
      { regex: /for\s+(\w+),\s*(\w+)\s*:\s*(\w+)\s+in\s+(\w+)\s+do/g,
        format: "for $1, $2 in next, $4 do" },
    ];

    // Replace patterns with their respective formats
    patterns.forEach(({ regex, format }) => {
        luaScript = luaScript.replace(regex, format);
    });

    return luaScript;
}

let luaucode = `
local example = {
    ["hi"] = { fart = "im straight" },
    ["sir"] = "ur not, we are not the same"
}

-- LUAU STRING
local str = "hello"
str ..= " bruh"
example.sir ..= " lol"
example["hi"].fart ..= "-"

-- INT
local num = 1
num += 1 -- add 1
num += 2 -- add 2
num -= 2 -- sub 1
num *= 3 -- mul 3
num /= 3 -- div 3
print(num) -- 3

-- TYPES [ later ]
local player = game:GetService("Players").LocalPlayer
for i, v: Part in player.Character:GetChildren() do
    if not v.ClassName:find("Part") then
        continue -- not a part :(
    end

    print(v.Name)
end
`

let luacode = replacePatterns(luaucode)
console.log(luacode)
