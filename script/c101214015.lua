--스카이워커 메소스피어
function c101214015.initial_effect(c)
	--싱크로 소환
   aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),aux.NonTuner(nil),1)
   c:EnableReviveLimit()
	--공격력 디버프
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c101214015.adtg)
	e1:SetValue(-800)
	c:RegisterEffect(e1)
	--번 데미지
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdocon)
	e2:SetOperation(c101214015.spop)
	c:RegisterEffect(e2)
	--LRM으로 소환시 체크
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c101214015.tncon)
	e3:SetOperation(c101214015.tnop)
	c:RegisterEffect(e3)	
end
function c101214015.filter(c)
	return ((c:IsSetCard(0x9ec7) and c:IsType(TYPE_SPELL)) or (c:IsSetCard(0xef5) and c:IsType(TYPE_MONSTER))) and c:IsAbleToGrave()
end
function c101214015.adtg(e,c)
	local lv=e:GetHandler():GetLevel()
	return c:GetLevel()<lv or c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK)
end
function c101214015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(2)
		c:RegisterEffect(e1)
	end
	Duel.Damage(1-tp,c:GetLevel()*200,REASON_EFFECT)
	if c:GetFlagEffect(101214015)>0 then
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c101214015.tncon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x9ec7)
end
function c101214015.tnop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(101214015,RESET_EVENT+0x1fe0000,0,1)
end