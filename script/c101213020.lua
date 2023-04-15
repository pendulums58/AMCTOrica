--월하의 결연희
function c101213020.initial_effect(c)
	--링크 소환
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),2,4,c101213020.lcheck)
	c:EnableReviveLimit()
	--순수 취급
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(101213009)
	c:RegisterEffect(e1)
	--직공
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c101213020.attg)
	e2:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e2)
	--특수 소환
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c101213020.target)
	e3:SetOperation(c101213020.activate)
	c:RegisterEffect(e3)
end
function c101213020.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xef3)
end
function c101213020.attg(e,c)
	local lg=e:GetHandler():GetLinkedGroup()
	return c:IsSetCard(0xef3) and lg:IsContains(c)
end
function c101213020.filter1(c,e,tp)
	local rk=c:GetLink()
	return c:IsFaceup() and c:IsSetCard(0xef3) and c:IsType(TYPE_LINK)
		and Duel.IsExistingMatchingCard(c101213020.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c,rk)
end
function c101213020.filter2(c,e,tp,mc,rk)
	return (c:GetLink()==rk or c:GetLink()==rk+1) and c:IsSetCard(0xef3) and mc:IsCanBeLinkMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c101213020.chainlm(e,rp,tp)
	return tp==rp
end
function c101213020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c101213020.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101213020.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetChainLimit(c101213020.chainlm)
end
function c101213020.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoGrave(tc,REASON_EFFECT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101213020.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc,tc:GetLink())
		local sc=g:GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end