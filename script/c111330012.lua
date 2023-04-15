--잔불이 스러져가는 거리
function c111330012.initial_effect(c)
	--발동시 효과 처리
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c111330012.activate)
	c:RegisterEffect(e0)
	--데미지 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c111330012.atkcon)
	e2:SetOperation(c111330012.atkop)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111330012,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_RELEASE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c111330012.atkcon)
	e3:SetOperation(c111330012.atkop)
	c:RegisterEffect(e3)
	--묘지 소생
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetCost(c111330012.spcost)
	e4:SetTarget(c111330012.sptg)
	e4:SetOperation(c111330012.spop)
	c:RegisterEffect(e4)
end
function c111330012.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,111330999) 
		and Duel.IsExistingMatchingCard(c111330012.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(111330012,0)) then
			local sg=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,111330999)
			if Duel.Release(sg,REASON_COST)~=0 then
				local g=Duel.SelectMatchingCard(tp,c111330012.thfilter,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
				end
			end
	end
end
function c111330012.thfilter(c)
	return c:IsSetCard(0x638) and c:IsAbleToHand()
end
function c111330012.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsCode,1,nil,111330999)
end
function c111330012.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end
function c111330012.cfilter(c,ft,tp)
	return c:IsCode(111330999) and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function c111330012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c111330012.cfilter,1,nil,ft,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c111330012.cfilter,1,1,nil,ft,tp)
	Duel.Release(sg,REASON_COST)
end
function c111330012.filter(c,e,tp)
	return c:IsSetCard(0x638) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c111330012.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c111330012.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c111330012.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c111330012.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c111330012.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end