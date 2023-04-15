--시계탑의 관찰자
function c101213320.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101213320.pfilter,c101213320.mfilter,2,2)	
	c:EnableReviveLimit()
	--유옥에 완전내성 부여
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCondition(c101213320.immcon)
	e1:SetTarget(c101213320.etarget)
	e1:SetValue(c101213320.efilter)
	c:RegisterEffect(e1)
	--전투 내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101213320.indtg)
	e2:SetValue(c101213320.indval)
	c:RegisterEffect(e2)
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101213320,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c101213320.spcon)
	e3:SetTarget(c101213320.target1)
	e3:SetOperation(c101213320.operation1)
	c:RegisterEffect(e3)
end
function c101213320.pfilter(c)
	return c:IsSetCard(0x60a) and (c:GetLevel()==5 or c:GetRank()==5)
end
function c101213320.mfilter(c,pair)
	return c:GetAttack()<pair:GetAttack()
end
function c101213320.immcon(e)
	local pr=e:GetHandler():GetPair()
	return pr:GetCount()>0 and pr:IsExists(Card.GetSummonLocation,1,nil,LOCATION_EXTRA)
end
function c101213320.etarget(e,c)
	return c:IsCode(CARD_CLOCKTOWER)
end
function c101213320.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c101213320.indtg(e,c)
	e:SetLabel(c:GetAttack())
	return c:IsSetCard(0x60a)
end
function c101213320.indval(e,c)
	local dam=Duel.GetBattleDamage(tp)
	if dam<e:GetLabel() then return true end
	return false
end
function c101213320.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_PAIR)
end
function c101213320.filter(c)
	return c:IsSetCard(0x60a) and c:IsAbleToHand()
end
function c101213320.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101213320.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101213320.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101213320.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
