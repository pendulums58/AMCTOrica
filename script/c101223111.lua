--성사의 신녀
function c101223111.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223111.pfilter,c101223111.mfilter,1,1)
	c:EnableReviveLimit()	
	--속성 추가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	--성사의 신식
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101223111,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101223111.tgcon)
	e2:SetTarget(c101223111.tgtg)
	e2:SetOperation(c101223111.tgop)
	c:RegisterEffect(e2)
end
function c101223111.pfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c101223111.mfilter(c,pair)
	return c:GetDefense()==pair:GetAttack()
end
function c101223111.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:IsPreviousLocation(LOCATION_GRAVE) and tc:IsControler(tp) and tc:IsType(TYPE_MONSTER)
end
function c101223111.filter(c,att)
	return not c:IsAttribute(att) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c101223111.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101223111.filter,tp,LOCATION_DECK,0,1,nil,eg:GetFirst():GetAttribute()) end
	e:SetLabel(eg:GetFirst():GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101223111.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101223111.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
