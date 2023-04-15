--한정해제자 체이시아
function c101252009.initial_effect(c)
	--의식으로 취급
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)	
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(TYPE_RITUAL)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetRange(LOCATION_DECK)
	e0:SetValue(TYPE_RITUAL)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)	
	c:RegisterEffect(e0)
	--엑덱 덤핑 + LP 회복
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cyan.RitSSCon)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,101252009)
	e2:SetTarget(c101252009.tgtg)
	e2:SetOperation(c101252009.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c101252009.tgcon)
	c:RegisterEffect(e3)
	--자가 회수
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c101252009.thcon)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,101252109)
	e4:SetTarget(c101252009.thtg)
	e4:SetOperation(c101252009.thop)
	c:RegisterEffect(e4)
end
function c101252009.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x625)
end
function c101252009.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101252009.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c101252009.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c101252009.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local tc=g:GetFirst()
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end
function c101252009.tgfilter(c)
	return (c:IsLevelBelow(4) or c:IsRankBelow(4)) and c:IsAbleToGrave() and c:GetAttack()>0
end
function c101252009.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c101252009.tgchk,1,nil,tp)
end
function c101252009.tgchk(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:IsType(TYPE_RITUAL)
end
function c101252009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c101252009.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end