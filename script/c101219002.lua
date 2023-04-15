--라디언트나이트 메티스
local s,id=GetID()
function s.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,id)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--함정 내성 부여
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_HAND)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(s.efcon)
	e3:SetTarget(s.tg)
	e3:SetValue(s.tgval)
	c:RegisterEffect(e3)	
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	if not Duel.IsExistingMatchingCard(s.drchk,tp,LOCATION_GRAVE,0,1,nil) then
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,LOCATION_DECK)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(g,1-tp)
		if e:GetLabel()==1 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function s.thfilter(c)
	return c:IsSetCard(SETCARD_RADIANT) and c:IsAbleToHand()
end
function s.drchk(c)
	return c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.efcon(e,c)
	return e:GetHandler():IsPublic()
end
function s.tgval(e,re,rp)
	return aux.tgoval(e,re,rp) and re:IsActiveType(TYPE_TRAP)
end
function s.tg(e,c)
	return c:IsType(TYPE_RITUAL) and c:IsFaceup() and c:IsSetCard(SETCARD_RADIANT)
end