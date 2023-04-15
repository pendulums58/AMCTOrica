--꿈 소굴의 루러스
function c101223107.initial_effect(c)
	--단짝 세팅
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_DECK)
	e0:SetTarget(c101223107.comptg)
	e0:SetOperation(c101223107.compop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetRange(LOCATION_HAND)
	c:RegisterEffect(e1)	
	--사자소생
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,101223107)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c101223107.target)
	e2:SetOperation(c101223107.activate)
	c:RegisterEffect(e2)	
end
function c101223107.comptg(e,tp,ep,eg,ev,re,r,rp,chk)
	local p=e:GetHandler():GetControler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(p,COMPANION_COMPLETE)
		and not Duel.IsExistingMatchingCard(c101223107.cpfilter,p,LOCATION_DECK+LOCATION_HAND,0,1,e:GetHandler(),p)
		and Duel.GetTurnCount()==1 end
end
function c101223107.cpfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()>2
end
function c101223107.compop(e,tp,ep,eg,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(p,COMPANION_COMPLETE) then return end
	if Duel.SelectYesNo(p,aux.Stringid(101223107,0)) then
		cyan.companiontheffect(c)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(COMPANION_COMPLETE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,p)
	end
end
function c101223107.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101223107.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c101223107.filter(chkc,e,tp) and c:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101223107.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101223107.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101223107.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
