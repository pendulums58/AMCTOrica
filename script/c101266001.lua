--유니에이트 가드
function c101266001.initial_effect(c)
	--자체 통상 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101266001,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101266001)
	e1:SetCondition(c101266001.sumcon)
	e1:SetCost(c101266001.sumcost)
	e1:SetTarget(c101266001.sumtg)
	e1:SetOperation(c101266001.sumop)
	c:RegisterEffect(e1)	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cyan.selftdcost)
	e2:SetCondition(c101266001.sumcon)
	e2:SetTarget(c101266001.thtg)
	e2:SetOperation(c101266001.thop)
	c:RegisterEffect(e2)
end
function c101266001.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return 1-tp==Duel.GetTurnPlayer()
end
function c101266001.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x634) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x634)
	Duel.Release(g,REASON_COST)
end
function c101266001.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonable(true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c101266001.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	if not e:GetHandler():IsSummonable(true,nil) then return end
	if Duel.Summon(tp,e:GetHandler(),true,nil)~=0 then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(c101266001.efilter)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		e4:SetOwnerPlayer(tp)
		e:GetHandler():RegisterEffect(e4)
	end
end
function c101266001.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c101266001.filter(c)
	return c:IsSetCard(0x634) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function c101266001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101266001.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101266001.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101266001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
			and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(101266001,1)) then
			local g1=Duel.SelectMatchingCard(tp,c101266001.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if g1:GetCount()>0 then
				Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			end	
		end
	end
end
function c101266001.filter1(c,e,tp)
	return c:IsLevelAbove(5) and c:IsSetCard(0x634) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end