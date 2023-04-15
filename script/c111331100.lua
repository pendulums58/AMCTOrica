--시간 속에 뛰어든 소녀
function c111331100.initial_effect(c)
--link summon
	aux.AddLinkProcedure(c,nil,2,2,c111331100.lcheck)
	c:EnableReviveLimit()	
--서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111331100,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)	
	e1:SetCountLimit(1,111331100)
	e1:SetCondition(c111331100.con)
	e1:SetTarget(c111331100.tg)
	e1:SetOperation(c111331100.op)
	c:RegisterEffect(e1)
end
--조건
function c111331100.lcheck(g)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
--서치
function c111331100.con(e)
	return e:GetHandler():GetLinkedGroupCount()>1
end
function c111331100.filter(c)
	return c:IsCode(50292967,87902575) and c:IsAbleToHand()
end
function c111331100.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111331100.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c111331100.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c111331100.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

