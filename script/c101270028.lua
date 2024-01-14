--창휘찬조 - 글로리윙
local s,id=GetID()
function s.initial_effect(c)
	--공격력
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	--연속 공격
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(s.spcon)
	cyan.JustDraw(e3,1)
	c:RegisterEffect(e3)	
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local cet=e:GetHandler():GetEquipTarget()
	return ep~=tp and ev>=2000 and ((eg and eg:GetFirst()==cet) or (re and re:GetHandler()==cet))
		
end