--창성관리자『종언성건』
function c101248015.initial_effect(c)
	c:SetUniqueOnField(1,0,101245015)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c101248015.filter),11,2)
	c:EnableReviveLimit()	
end
function c101248015.filter(c)
	return c:IsSetCard(0x622) or c:IsSetCard(0x620)
end