--비 갠 후의 비스트헌터
--Scripted by Cyan
function c101223005.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223005.pfilter,c101223005.mfilter,2)
	c:EnableReviveLimit()
	--공뻥
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101223005,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c101223005.atkcon)
	e1:SetTarget(c101223005.atktg)
	e1:SetOperation(c101223005.atkop)
	c:RegisterEffect(e1)	
end
function c101223005.pfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(4)
end
function c101223005.mfilter(c,pair)
	return c:GetLevel()==pair:GetLevel()
end
function c101223005.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PAIRING)
end
function c101223005.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return c:GetPair():GetCount()>0 and c:GetPair():GetSum(Card.GetAttack)>0 end
	local g=c:GetMaterial()
	if g:GetCount()>0 then
		local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,g:GetCount(),nil)
	end
end
function c101223005.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pr=c:GetPair():GetFirst()
	if pr and pr:GetAttack()>0 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local atk=pr:GetAttack()
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(atk)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
