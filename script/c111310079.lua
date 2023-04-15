--아주르 나이트블룸
c111310079.AccessMonsterAttribute=true
function c111310079.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,c111310079.afil1)
	c:EnableReviveLimit()	
	--아크나이츠!
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(111310079,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cyan.adcon)
	e1:SetCountLimit(1)
	e1:SetTarget(c111310079.target)
	e1:SetOperation(c111310079.operation)
	c:RegisterEffect(e1)	
	--효과 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c111310079.efilter)
	c:RegisterEffect(e2)	
end
function c111310079.afil1(c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c111310079.filter(c,ac)
	return c:IsCanBeAdmin(ac) and not c:IsAttribute(ATTRIBUTE_WIND) and c:IsFaceup()
end
function c111310079.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c111310079.filter(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(c111310079.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c111310079.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c111310079.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:GetAdmin()~=nil and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and tc:IsFaceup() then
		Duel.SendtoGrave(c:GetAdmin(),REASON_EFFECT)
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c111310079.efilter(e,te)
	local ad=e:GetHandler():GetAdmin()
	return ad and te:GetHandler():IsRace(ad:GetRace()) and not te:GetHander()==e:GetHandler()
end