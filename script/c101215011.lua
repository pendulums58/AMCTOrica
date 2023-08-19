--스타기어 메인테넌스
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCost(s.cost)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)	
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_SZONE,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_SZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetSetCard())
end
function s.cfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
		and Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_DECK,0,1,nil,c)
end
function s.cfilter1(c,tc)
	local tp=c:GetControler()
	return c:CheckUniqueOnField(tp,LOCATION_ONFIELD,tc) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
		and c:IsSetCardList(tc:GetSetCard()) and not c:IsForbidden() 
end
function s.cfilter2(c,code)
	return c:CheckUniqueOnField(tp) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
		and c:IsSetCardList(code) and not c:IsForbidden() 
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckGiftEffect(tp,s.gfilter) end
end
function s.gfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_DECK,0,1,1,nil,code)
	Duel.MoveToField(g,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.AddGiftEffect(e,s.gfilter,s.geffect,2200,1000)	
end
function s.geffect(e,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)	
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCondition(s.drcon)
	e1:SetCost(s.drcost)
	cyan.JustDraw(e1,1)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:IsActiveType(TYPE_SPELL) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.drcfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,s.drcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.drcfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end