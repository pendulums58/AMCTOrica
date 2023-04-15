--환영검사 코로멜
function c101255002.initial_effect(c)
	--생성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101255002)
	e1:SetCost(c101255002.mkcost)
	e1:SetOperation(c101255002.mkop)
	c:RegisterEffect(e1)
	--파괴하고 특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101255002,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101255002)
	e2:SetTarget(c101255002.destg)
	e2:SetOperation(c101255002.desop)
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
end
function c101255002.mkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c101255002.mkop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,101255008)
	Duel.SendtoHand(token,tp,REASON_EFFECT)
	local token1=Duel.CreateToken(tp,101255008)
	Duel.SendtoHand(token1,tp,REASON_EFFECT)
	local token2=Duel.CreateToken(tp,101255008)
	Duel.SendtoHand(token2,tp,REASON_EFFECT)
	local g=Group.CreateGroup()
	g:AddCard(token)
	g:AddCard(token1)
	g:AddCard(token2)
	Duel.ConfirmCards(1-tp,g)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101255002.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101255002.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x627)
end
function c101255002.desfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsType(TYPE_EQUIP) and c:IsSetCard(0x627)
end
function c101255002.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c101255002.desfilter(chkc,tp) end
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c101255002.desfilter,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101255002.desfilter,tp,LOCATION_SZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101255002.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end