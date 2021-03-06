AddCSLuaFile()
DEFINE_BASECLASS( "base_wire_entity" )
ENT.PrintName       = "Wire User"
ENT.WireDebugName	= "User"

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "BeamLength" )
end

if CLIENT then return end -- No more client

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.Inputs = Wire_CreateInputs(self, { "Fire"})
	self:Setup(2048)
end

function ENT:Setup(Range)
	if Range then self:SetBeamLength(Range) end
end

function ENT:TriggerInput(iname, value)
	if (iname == "Fire") then
		if (value ~= 0) then
			local vStart = self:GetPos()

			local trace = util.TraceLine( {
				start = vStart,
				endpos = vStart + (self:GetUp() * self:GetBeamLength()),
				filter = { self },
			})

			if not IsValid(trace.Entity) then return false end
			local ply = self:GetPlayer()
			if not IsValid(ply) then ply = self end
			
			if trace.Entity.Use then
				trace.Entity:Use(ply,ply,USE_ON,0)
			else
				trace.Entity:Fire("use","1",0)
			end
		end
	end
end

duplicator.RegisterEntityClass("gmod_wire_user", WireLib.MakeWireEnt, "Data", "Range")
