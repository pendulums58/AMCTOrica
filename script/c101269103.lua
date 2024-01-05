--CR(크로니클 레플리카)-절망의 마녀 오이노큐트
function c101269103.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,c101269103.afil1)
	c:EnableReviveLimit()	
	--공격력 절반
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_SINGLE)
   e1:SetRange(LOCATION_MZONE)
   e1:SetCode(EFFECT_SET_BASE_ATTACK)
   e1:SetCondition(cyan.adcon)
   e1:SetValue(2000)
   c:RegisterEffect(e1)
   --대상이 되었을 때
   local e2=Effect.CreateEffect(c)
   e2:SetDescription(aux.Stringid(101269103,0))
   e2:SetCategory(CATEGORY_NEGATE)
   e2:SetType(EFFECT_TYPE_QUICK_O)
   e2:SetCode(EVENT_BECOME_TARGET)
   e2:SetRange(LOCATION_MZONE)
   e2:SetCondition(c101269103.negcon)
   e2:SetCost(c101269103.negcost)
   e2:SetTarget(c101269103.negtg)
   e2:SetOperation(c101269103.negop)
   c:RegisterEffect(e2)
   --tohand
   local e3=Effect.CreateEffect(c)
   e3:SetDescription(aux.Stringid(101269103,0))
   e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
   e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
   e3:SetProperty(EFFECT_FLAG_DELAY)
   e3:SetCode(EVENT_TO_GRAVE)
   e3:SetCountLimit(1,101269103)
   cyan.JustSearch(e3,LOCATION_DECK,Card.IsCode,101269000)
   c:RegisterEffect(e3)
end
function c101269103.afil1(c)
   return c:IsSetCard(0x641)
end
function c101269103.negcon(e,tp,eg,ep,ev,re,r,rp)
   return eg:IsContains(e:GetHandler())
end
function c101269103.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
   local ad=e:GetHandler():GetAdmin()
   if chk==0 then return ad~=nil end
   Duel.SendtoGrave(ad,REASON_COST)
end
function c101269103.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
   Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
   end
   function c101269103.negop(e,tp,eg,ep,ev,re,r,rp)
   Duel.NegateEffect(ev)
end
function c101269103.thfilter(c)
	return c:IsCode(101269000) and c:IsAbleToHand()
end
function c101269103.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101269103.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101269103.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101269103.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
