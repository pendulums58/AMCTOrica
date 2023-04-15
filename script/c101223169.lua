--전생의 우연
function c101223169.initial_effect(c)
	--묘지 소생 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101223169)
	e1:SetTarget(c101223169.sptg)
	e1:SetOperation(c101223169.spop)
	c:RegisterEffect(e1)
	--묘지 소생 2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabelObject(e1)
	e2:SetCountLimit(1,101223169)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101223169.sptg1)
	e2:SetOperation(c101223169.spop)
	c:RegisterEffect(e2)
	--묘지 소생 3
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetLabelObject(e2)
	e3:SetCountLimit(1,101223169)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c101223169.spcost)
	e3:SetTarget(c101223169.sptg1)
	e3:SetOperation(c101223169.spop1)
	c:RegisterEffect(e3)
end
function c101223169.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE)
		and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(Card.IsCanBeSpecialSummoned,tp,LOCATION_GRAVE,0,1,nil,e,0,tp,false,false) end
	local tc=Duel.SelectTarget(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_GRAVE,0,1,1,nil,e,0,tp,false,false)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_GRAVE)
end
function c101223169.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		e:SetLabel(tc:GetCode())
	end
end
function c101223169.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local code=e:GetLabelObject():GetLabel()
	if chkc then return code and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE)
		and c101223169.spfilter(chkc,e,tp,code) end
	if chk==0 then return code and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101223169.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,code) end
	local tc=Duel.SelectTarget(tp,c101223169.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,code)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_GRAVE)
end
function c101223169.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101223169.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Exile(e:GetHandler(),REASON_COST)
end
function c101223169.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c101223169.sumlimit)
		e1:SetLabel(code)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2,tp)
	end
end
function c101223169.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end