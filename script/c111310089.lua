--ZIP 프로텍터
c111310089.AccessMonsterAttribute=true
function c111310089.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()
	--몬스터 파괴 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetCondition(c111310089.nscon)
	e1:SetValue(c111310089.efilter)
	c:RegisterEffect(e1)	
	--달의 서
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111310089,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c111310089.target2)
	e2:SetOperation(c111310089.activate2)
	c:RegisterEffect(e2)	
end
function c111310089.nscon(e,tp,eg,ep,ev,re,r,rp)
	local ad=e:GetHandler():GetAdmin()
	return ad and (ad:IsSetCard(0x606) or ad:IsAttribute(ATTRIBUTE_DARK)) 
end
function c111310089.efilter(e,re)
	return re:IsActiveType(TYPE_EFFECT)
end
function c111310089.filter2(c)
	return c:IsCanTurnSet()
end
function c111310089.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310089.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c111310089.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c111310089.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c111310089.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end