--컨티뉴엄 시프터
function c101235000.initial_effect(c)
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,101235000)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101235000.spcon)
	c:RegisterEffect(e1)
	--제외
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,101235900)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c101235000.cost)
	e2:SetTarget(c101235000.target)
	e2:SetOperation(c101235000.activate)
	c:RegisterEffect(e2)
end
function c101235000.spfilter1(c)
	return c:IsFaceup() and c:IsCode(81674782)
end
function c101235000.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101235000.spfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101235000.filter(c,e,tp,ty)
	local check=0
	return c:IsFaceup() and c:IsType(ty) and c:IsSetCard(0x653) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsSSetable())
end
function c101235000.cfilter(c,e,tp)
	local ty=c:GetType() & (TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c101235000.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp,ty)
end
function c101235000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then e:SetLabel(100)
		return Duel.IsExistingMatchingCard(c101235000.cfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101235000.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	local ty=g:GetFirst():GetType()
	e:SetLabel(ty)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c101235000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c101235000.spfilter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x653) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101235000.spfilter3(c)
	return c:IsFaceup() and c:IsSetCard(0x653) and c:IsSSetable()
end
function c101235000.activate(e,tp,eg,ep,ev,re,r,rp)
	local typ=e:GetLabel()
	if (typ & TYPE_MONSTER)>0 and Duel.IsExistingMatchingCard(c101235000.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,c101235000.spfilter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if (typ & TYPE_SPELL+TYPE_TRAP)>0 and Duel.IsExistingMatchingCard(c101235000.spfilter3,tp,LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local g1=Duel.SelectMatchingCard(tp,c101235000.spfilter3,tp,LOCATION_REMOVED,0,1,1,nil)
		local tc1=g1:GetFirst()
		if tc1 then
			Duel.SSet(tp,tc1)
		end		
	end
end