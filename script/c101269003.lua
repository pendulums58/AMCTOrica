--개화하는 이상
function c101269003.initial_effect(c)
   --발동
   local e1=Effect.CreateEffect(c)
   e1:SetCategory(CATEGORY_TOGRAVE)
   e1:SetType(EFFECT_TYPE_ACTIVATE)
   e1:SetCode(EVENT_FREE_CHAIN)
   e1:SetCountLimit(1,101269003)
   e1:SetTarget(c101269003.target)
   e1:SetOperation(c101269003.operation)
   c:RegisterEffect(e1)
   --묘지제외
   local e2=Effect.CreateEffect(c)
   e2:SetCategory(CATEGORY_TOHAND)
   e2:SetCost(aux.bfgcost)
   e2:SetCondition(aux.exccon)
   e2:SetRange(LOCATION_GRAVE)
   e1:SetCountLimit(1,101269003+100)
   e2:SetType(EFFECT_TYPE_IGNITION)
   cyan.JustSearch(e2,LOCATION_REMOVED,Card.IsSetCard,0x641)
   c:RegisterEffect(e2)
end
function c101269003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then Duel.IsExistingMatchingCard(c101269003.costfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
   local g=Duel.SelectMatchingCard(tp,c101269003.costfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
   if g:GetCount()>0 then
      Duel.SendtoGrave(g,REASON_COST)
      local rc=g:GetFirst():GetRace()
      e:SetLabel(rc)
   end
end
function c101269003.costfilter(c,tp)
   return c:IsSetCard(0x641) and c:IsAbleToGraveAsCost() and
      Duel.IsExistingMatchingCard(c101269003.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetRace())
end
function c101269003.tgfilter(c,rc)
   return c:IsSetCard(0x641) and c:IsAbleToGrave() and c:IsRace(rc)
end
function c101269003.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c101269003.costfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
   local g=Duel.SelectMatchingCard(tp,c101269003.costfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
   if g:GetCount()>0 then
      Duel.SendtoGrave(g,REASON_COST)
      local rc=g:GetFirst():GetRace()
      e:SetLabel(rc)
   end
   Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
end
function c101269003.operation(e,tp,eg,ep,ev,re,r,rp)
   local rc=e:GetLabel()
   local g=Duel.SelectMatchingCard(tp,c101269003.tgfilter,tp,LOCATION_DECK,0,1,1,nil,rc)
   if g:GetCount()>0 then
      Duel.SendtoGrave(g,REASON_EFFECT)
   end
end