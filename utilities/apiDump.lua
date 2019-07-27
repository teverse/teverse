-- Utility script to generate an API dump in JSON format.
-- Requires workshop level sandbox
-- WIP

function dumpObject(object)
 local objectDump = {
  properties = {},
  methods = {},
  events = {}
 }
 
 for _,v in pairs(workshop:getMembersOfInstance(object)) do
  if type(object[v.property]) == "function" then
    objectDump.methods[v.property] = {
      parameters = {},
      returns = {}
    }
  else
    objectDump.properties[v.property] = type(object[v.property])
  end
 end
 
 return objectDump
end

local engineDumped = dumpObject(engine)
print(engine.json:encode(engineDumped))