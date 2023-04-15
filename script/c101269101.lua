--CR 전장의 영웅 보디세우스
c101269101.AccessMonsterAttribute=true
function c101269101.initial_effect(c)
   --액세스 소환
   cyan.AddAccessProcedure(c,c101269101.afil1,c101269101.afil2)
   c:EnableReviveLimit()
   --공격력 절반
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_SINGLE)
   e1:SetRange(LOCATION_MZONE)
   e1:SetCode(EFFECT_SET_BASE_ATTACK)
   e1:SetCondition(cyan.adcon)
   e1:SetValue(2500)
   c:RegisterEffect(e1)
   --대상이 되었을 때
   local e2=Effect.CreateEffect(c)
   e2:SetDescription(aux.Stringid(101269101,0))
   e2:SetCategory(CATEGORY_NEGATE)
   e2:SetType(EFFECT_TYPE_QUICK_O)
   e2:SetCode(EVENT_BECOME_TARGET)
   e2:SetRange(LOCATION_MZONE)
   e2:SetCondition(c101269101.negcon)
   e2:SetCost(c101269101.negcost)
   e2:SetTarget(c101269101.negtg)
   e2:SetOperation(c101269101.negop)
   c:RegisterEffect(e2)
   --전투 실행 후
   local e3=Effect.CreateEffect(c)
   e3:SetDescription(aux.Stringid(101269101,1))
   e3:SetCategory(CATEGORY_DESTROY)
   e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
   e3:SetCode(EVENT_BATTLED)
   e3:SetTarget(c101269101.tgtg)
   e3:SetOperation(c101269101.tgop)
   c:RegisterEffect(e3)
end
function c101269101.afil1(c)
   return c:IsRace(RACE_WARRIOR)
end
function c101269101.afil2(c)
   return c:IsSetCard(0x641)
end
function c101269101.negcon(e,tp,eg,ep,ev,re,r,rp)
   return eg:IsContains(e:GetHandler())
end
function c101269101.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
   local ad=e:GetHandler():GetAdmin()
   if chk==0 then return ad~=nil end
   Duel.SendtoGrave(ad,REASON_COST)
   if ad:IsRace(RACE_WARRIOR) then e:SetLabel(1) end
end
function c101269101.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
   Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
   if e:GetLabel()==1 then
      Duel.SetOperationInfo(0,CATEGORY_DRAW,0,1,tp,0)
   end
end
function c101269101.negop(e,tp,eg,ep,ev,re,r,rp)
   Duel.NegateEffect(ev)
   if e:GetLabel()==1 then
      Duel.Draw(tp,1,REASON_EFFECT)
   end
end
function c101269101.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
   Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c101269101.tgop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
   local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
   if g:GetCount()>0 then
      Duel.Destroy(g,REASON_EFFECT)
      Duel.Recover(tp,800,REASON_EFFECT)
   end
end
