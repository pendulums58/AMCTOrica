--환영검성 재니스
c101255004.AccessMonsterAttribute=true
function c101255004.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_EQUIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101255004)
	e1:SetCondition(c101255004.drcon)
	e1:SetTarget(c101255004.drtg)
	e1:SetOperation(c101255004.drop)
	c:RegisterEffect(e1)
	--공뻥
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c101255004.atkval)
	c:RegisterEffect(e2)	
end
function c101255004.drfilter(c)
	return c:GetEquipTarget():IsSetCard(0x627)
end
function c101255004.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101255004.drfilter,1,nil)
end
function c101255004.filter(c,e,tp)
	return c:IsSetCard(0x627) and not c:IsType(TYPE_ACCESS) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c101255004.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101255004.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101255004.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101255004.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101255004.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101255004.cfilter(c)
	return c:IsFaceup() and c:IsCode(101255008)
end
function c101255004.atkval(e,c)
	return Duel.GetMatchingGroupCount(c101255004.cfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*400
end