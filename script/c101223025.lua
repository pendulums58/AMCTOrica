--스페이스 하리네즈미
function c101223025.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223025.pfilter,c101223025.mfilter,1,1)
	c:EnableReviveLimit()	
	--직접 공격
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101223025,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c101223025.condition)
	e2:SetTarget(c101223025.target)
	e2:SetOperation(c101223025.operation)
	c:RegisterEffect(e2)
end
function c101223025.pfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c101223025.mfilter(c,pair)
	return c:GetDefense()==pair:GetDefense()
end
function c101223025.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c101223025.filter(c,e,tp,pr)
	return pr:IsExists(Card.IsRace,1,nil,c:GetRace()) and pr:IsExists(Card.IsAttribute,1,nil,c:GetAttribute())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101223025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local pr=e:GetHandler():GetPair()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101223025.filter(chkc,e,tp,pr) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101223025.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,pr) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101223025.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,pr)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101223025.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end