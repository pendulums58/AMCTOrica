--한정해제-수용
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()	
	--패 발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--특소시 발동
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then Duel.IsExistingTarget(s.desfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_GRAVE,1,nil) end
	local g1=Duel.SelectTarget(tp,s.desfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_GRAVE,1,1,nil)
	e:SetLabelObject(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)	
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)	
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g1=e:GetLabelObject()
	g:Sub(g1)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
	local tg1=g1:Filter(Card.IsRelateToEffect,nil,e)
	if #tg1>0 then
		Duel.Remove(tg1,POS_FACEUP,REASON_EFFECT)
	end
end
function s.desfilter1(c)
	return c:IsFaceup() and c:IsSetCard(SETCARD_FOREGONE)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW+CATEGORY_TOHAND,nil,ct,tp,0)
	Duel.SetChainLimit(s.chlimit)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	if Duel.Draw(tp,ct,REASON_EFFECT)~=0 then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function s.chlimit(e,ep,tp)
	return tp==ep or not e:GetHandler():IsFacedown()
end