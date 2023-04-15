--유니에이트 프로미스
function c101266005.initial_effect(c)
	--아무거나 서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101266005)
	cyan.JustSearch(e1,LOCATION_DECK,Card.IsSetCard,0x634)
	c:RegisterEffect(e1)
	--묘지 발동
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101266105)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c101266005.con)
	cyan.JustSearch(e2,LOCATION_DECK,Card.IsSetCard,0x634,Card.IsType,TYPE_MONSTER)
	c:RegisterEffect(e2)
end
function c101266005.con(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end