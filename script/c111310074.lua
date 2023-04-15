--퍼스트아이 컨택터
c111310074.AccessMonsterAttribute=true
function c111310074.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,c111310074.afil1,c111310074.afil2)
	c:EnableReviveLimit()
	--패 공개
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e1)
	--함정 발동 불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c111310074.limcon)
	e2:SetValue(c111310074.aclimit)
	c:RegisterEffect(e2)
	--빛 속성 서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(111310074,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,111310074)
	e3:SetCondition(c111310074.thcon)
	e3:SetTarget(c111310074.thtg)
	e3:SetOperation(c111310074.thop)
	c:RegisterEffect(e3)
end
function c111310074.afil1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c111310074.afil2(c)
	return c:GetAttack()<=1500
end
function c111310074.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAdmin()~=nil
end
function c111310074.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_TRAP)
end
function c111310074.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c111310074.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function c111310074.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111310074.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c111310074.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c111310074.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end