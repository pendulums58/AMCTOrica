--이별 벚꽃
function c103555000.initial_effect(c)
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cyan.selfdiscost)
	e1:SetCondition(c103555000.con)
	e1:SetCountLimit(1,103555000)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsSetCard,0x65a,Card.IsNotCode,103555000)
	c:RegisterEffect(e1)
	cyan.AddSakuraEffect(c)
end
function c103555000.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		or Duel.IsPlayerAffectedByEffect(c:GetControler(),103555011)
end