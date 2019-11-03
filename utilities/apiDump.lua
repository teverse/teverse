-- Utility script to generate an API dump in JSON format.
-- Requires workshop level sandbox
-- WIP
return function (workshop)
  local dump = {}

  local function dumpObject(object)
   local objectDump = {
    properties = {},
    methods = {},
    events = {}
   }
   
   for _,v in pairs(workshop:getMembersOfInstance(object)) do
    if not v.inherited then
      if type(object[v.property]) == "function" then
        objectDump.methods[v.property] = {}
        if v.docs then
          objectDump.methods[v.property].returns = v.docs.returns
          objectDump.methods[v.property].parameters = v.docs.parameters 
        end
      else
        objectDump.properties[v.property] = type(object[v.property])
      end
    end
   end
   
   return objectDump
  end

  print("Generating dump")
  local engineDumped = dumpObject(engine)
  print(engine.json:encode(engineDumped))
end