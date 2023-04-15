--조각난 하늘의 던시커
function c101223112.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,aux.TRUE,c101223112.mfilter,2,2)
	c:EnableReviveLimit()
	--파괴 적용 불가 부여
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetOperation(c101223112.sdop)
	e1:SetCondition(cyan.PairSSCon)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)	
	--달의 서
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101223112.target)
	e2:SetOperation(c101223112.activate)	
	c:RegisterEffect(e2)
end
function c101223112.mfilter(c,pair)
	return c:GetDefense()<pair:GetDefense()
end
function c101223112.filter(c,g)
	return c:IsFaceup() and c:IsCanTurnSet() and g:IsExists(Card.IsAttackBelow,1,nil,c:GetAttack()-1)
end
function c101223112.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetPair()
	if g:GetCount()==0 then return false end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101223112.filter(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(c101223112.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101223112.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c101223112.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
